package gatepass;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.Base64;

import jakarta.servlet.ServletConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/saveContractLabourData")
@MultipartConfig
public class SaveContractLabourData extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    public void init(ServletConfig config) throws ServletException {
        super.init(config);
        System.out.println("✅ SaveContractLabourData Servlet Initialized");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {

        System.out.println("➡ SaveContractLabourData.doPost invoked");
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();

        Connection conn = null;
        PreparedStatement ps = null;
        FileInputStream fis = null;

        try {
            // ✅ Get Photo Base64
            String imageBase64 = request.getParameter("imageData");
            if (imageBase64 == null || imageBase64.trim().isEmpty()) {
                throw new Exception("Please capture a photo before submitting!");
            }

            if (imageBase64.startsWith("data:image"))
                imageBase64 = imageBase64.substring(imageBase64.indexOf(",") + 1);

            byte[] imageBytes = Base64.getDecoder().decode(imageBase64);

            // ✅ Image save to folder
            String saveDir = "C:/GatepassImages/ContractLabour";
            File folder = new File(saveDir);
            if (!folder.exists()) folder.mkdirs();

            int srNo = parseIntOrDefault(request.getParameter("srNo"), 0);
            File imageFile = new File(saveDir + "/ContractLabour_" + srNo + ".png");

            try (FileOutputStream fos = new FileOutputStream(imageFile)) {
                fos.write(imageBytes);
            }

            System.out.println("📷 Image saved at: " + imageFile.getAbsolutePath());

            // ✅ Get form fields
            int refNo = parseIntOrDefault(request.getParameter("refNo"), -1);
            int age = parseIntOrDefault(request.getParameter("age"), 0);

            String renwlTypeSel = getParam(request, "renwlTypeSel", "");
            String name = getParam(request, "name", "");
            String fatherName = getParam(request, "fatherName", "");
            String desig = getParam(request, "desig", "");
            String localAddress = getParam(request, "localAddress", "");
            String permanentAddress = getParam(request, "permanentAddress", "");
            String contrctrNameAddress = getParam(request, "contrctrNameAddress", "");
            String vehicleNumber = getParam(request, "vehicleNumber", "");
            String identification = getParam(request, "identification", "");
            String valdity_fromDate = getParam(request, "valdity_fromDate", "");
            String valdity_toDate = getParam(request, "valdity_toDate", "");

            // ✅ DB Connection
            Database db = new Database();
            conn = db.getConnection();

            ps = conn.prepareStatement(
                    "INSERT INTO GATEPASS_CONTRACT_LABOUR (SER_NO, REF_NO, RENEWAL_NO, "
                            + "NAME, FATHER_NAME, DESIGNATION, AGE, LOCAL_ADDRESS, PERMANENT_ADDRESS, "
                            + "CONTRACTOR_NAME_ADDRESS, VEHICLE_NO, IDENTIFICATION, "
                            + "VALIDITY_PERIOD_FROM, VALIDITY_PERIOD_TO, PHOTO_IMAGE, UPDATE_DATE, UPDATE_BY) "
                            + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, TO_DATE(?, 'YYYY-MM-DD'), TO_DATE(?, 'YYYY-MM-DD'), ?, ?, ?)");

            ps.setInt(1, srNo);
            if (refNo == -1)
                ps.setNull(2, java.sql.Types.INTEGER);
            else
                ps.setInt(2, refNo);

            ps.setString(3, renwlTypeSel);
            ps.setString(4, name);
            ps.setString(5, fatherName);
            ps.setString(6, desig);
            ps.setInt(7, age);
            ps.setString(8, localAddress);
            ps.setString(9, permanentAddress);
            ps.setString(10, contrctrNameAddress);
            ps.setString(11, vehicleNumber);
            ps.setString(12, identification);

            ps.setString(13, valdity_fromDate);
            ps.setString(14, valdity_toDate);

            // ✅ Keep image stream open until after executeUpdate
            fis = new FileInputStream(imageFile);
            ps.setBinaryStream(15, fis, (int) imageFile.length());

            CommonService cs = new CommonService();
            ps.setString(16, cs.selectDateTime().toString());
            ps.setInt(17, 0); // UPDATE_BY or FLAG

            int result = ps.executeUpdate();
            if (result == 1) {
                System.out.println("✅ Data Inserted Successfully");
                request.getRequestDispatcher("PrintContractLabour.jsp?srNo=" + srNo)
                        .forward(request, response);
            } else {
                out.println("<h3>❌ Failed to Insert Data</h3>");
            }

        } catch (Exception e) {
            e.printStackTrace();
            out.println("<h3>Error: " + e.getMessage() + "</h3>");

        } finally {
            if (fis != null) fis.close();
            if (ps != null)
				try {
					ps.close();
				} catch (SQLException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
            if (conn != null)
				try {
					conn.close();
				} catch (SQLException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
        }
    }

    // Utility
    private int parseIntOrDefault(String val, int def) {
        try { return (val == null || val.trim().isEmpty()) ? def : Integer.parseInt(val); }
        catch (Exception e) { return def; }
    }

    private String getParam(HttpServletRequest req, String key, String def) {
        String v = req.getParameter(key);
        return (v == null || v.trim().isEmpty()) ? def : v.trim();
    }
}
