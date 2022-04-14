package herramientas;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.net.MalformedURLException;
import java.net.URL;

import org.jfree.report.JFreeReport;
import org.jfree.report.JFreeReportBoot;
import org.jfree.report.ReportProcessingException;
import org.jfree.report.modules.output.table.html.HtmlReportUtil;
import org.jfree.resourceloader.Resource;
import org.jfree.resourceloader.ResourceCreationException;
import org.jfree.resourceloader.ResourceException;
import org.jfree.resourceloader.ResourceKeyCreationException;
import org.jfree.resourceloader.ResourceLoadingException;
import org.jfree.resourceloader.ResourceManager;

public class Refere {

	/**
	 * @param args
	 * @throws ResourceException 
	 * @throws ReportProcessingException 
	 * @throws MalformedURLException 
	 */
	public static void main(String[] args) throws ResourceException, ReportProcessingException, MalformedURLException {
		JFreeReport reporte = null;
		JFreeReportBoot.getInstance().start();
		String htmlString;
		String reportPath = "file:parameters1.prpt";
		    //File reportLocation = new File("C:\reporte.prpt");
			//String reportPath = "file:" +
			//this.getServletContext().getRealPath("sampleReport.prpt");
		
		    ResourceManager manager = new ResourceManager();
		    manager.registerDefaults();
		    Resource resource = manager.createDirectly(new URL(reportPath), JFreeReport.class);
		    reporte = (JFreeReport) resource.getResource();
			ByteArrayOutputStream byteArray = new ByteArrayOutputStream();
			HtmlReportUtil.createStreamHTML(reporte, byteArray);
			htmlString = byteArray.toString();
		
		
	}

}
