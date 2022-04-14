package reporte;

import general.controlador.ParametrosSessionControlador;
import herramientas.Constantes;
import herramientas.Utileria;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.net.URL;
import java.util.Iterator;
import java.util.Locale;
import java.util.Map;

import org.pentaho.reporting.engine.classic.core.ClassicEngineBoot;
import org.pentaho.reporting.engine.classic.core.MasterReport;
import org.pentaho.reporting.engine.classic.core.modules.output.pageable.pdf.PdfReportUtil;
import org.pentaho.reporting.engine.classic.core.modules.output.table.html.HtmlReportUtil;
import org.pentaho.reporting.engine.classic.core.util.LibLoaderResourceBundleFactory;
import org.pentaho.reporting.libraries.resourceloader.Resource;
import org.pentaho.reporting.libraries.resourceloader.ResourceManager;

public class Reporte {
	

	/**
	 * Crea el reporte en la versión HTML
	 * @param nombreReporte : Nombre completo del reporte (Por lo General se define esto en el xml del controlador del reporte)
	 * @param parametrosReporte : {@link ParametrosReporte} Bean con el Hashmap de los parametros a recibir el PRPT
	 * @param rutaReportes : Ruta completa de la ubicación del repositorio de los reportes. (En Multibase se define esto en la BD principal.USUARIOS)
	 * @param rutaImgReportes : Ruta completa del logo del Cliente. (En Multibase se define esto en la BD principal.USUARIOS)
	 * @return String
	 * @throws Exception
	 */
	public static String creaHtmlReporte(String nombreReporte, ParametrosReporte parametrosReporte, String rutaReportes, String rutaImgReportes) throws Exception {
		ClassicEngineBoot.getInstance().start();
		String htmlString = null;
		String path = rutaReportes + nombreReporte;
		File filePath = new File(path);
		URL reportDefinition = filePath.toURI().toURL();
		try {
			ResourceManager manager = new ResourceManager();
			manager.registerDefaults();
			Resource res = manager.createDirectly(reportDefinition, MasterReport.class);
			MasterReport reporte = (MasterReport) res.getResource();
			LibLoaderResourceBundleFactory f = (LibLoaderResourceBundleFactory) reporte.getResourceBundleFactory();
			f.setLocale(Locale.US);
			if (parametrosReporte != null) {

				String safilocaleCliente = "safilocale.cliente";
				String safilocaleCtaAhorro = "safilocale.ctaAhorro";
				safilocaleCliente = Utileria.generaLocale(safilocaleCliente, ParametrosSessionControlador.parametrosSesionBean.getNomCortoInstitucion());
				safilocaleCtaAhorro = Utileria.generaLocale(safilocaleCtaAhorro, ParametrosSessionControlador.parametrosSesionBean.getNomCortoInstitucion());
				String fechaSistema = String.valueOf(ParametrosSessionControlador.parametrosSesionBean.getFechaAplicacion() + "");
				parametrosReporte.agregaParametro("Par_FechaSistema", fechaSistema);
				parametrosReporte.agregaParametro("Par_RutaImagen", rutaImgReportes);
				parametrosReporte.agregaParametro("Par_SafiLocale", safilocaleCliente);
				parametrosReporte.agregaParametro("Par_SafiLocaleCta", safilocaleCtaAhorro);
				agregraParametros(reporte, parametrosReporte);
			}

			ByteArrayOutputStream byteArray = new ByteArrayOutputStream();
			HtmlReportUtil.createStreamHTML(reporte, byteArray);
			htmlString = byteArray.toString();

		} catch (Exception e) {
			e.printStackTrace();
			htmlString = Constantes.htmlErrorReporte;

		}
		return htmlString;
	}

	private static void agregraParametros(MasterReport reporte, ParametrosReporte parametrosReporte) {
		Iterator it = parametrosReporte.getParametros().entrySet().iterator();
		while (it.hasNext()) {
			Map.Entry e = (Map.Entry) it.next();
			reporte.getParameterValues().put((String) e.getKey(), e.getValue());
		}
	}
	/**
	 * Crea el reporte en la versión PDF
	 * @param nombreReporte : Nombre completo del reporte (Por lo General se define esto en el xml del controlador del reporte)
	 * @param parametrosReporte : {@link ParametrosReporte} Bean con el Hashmap de los parametros a recibir el PRPT
	 * @param rutaReportes : Ruta completa de la ubicación del repositorio de los reportes. (En Multibase se define esto en la BD principal.USUARIOS)
	 * @param rutaImgReportes : Ruta completa del logo del Cliente. (En Multibase se define esto en la BD principal.USUARIOS)
	 * @return String
	 * @throws Exception
	 */
	public static ByteArrayOutputStream creaPDFReporte(String nombreReporte, ParametrosReporte parametrosReporte, String rutaReportes, String rutaImgReportes) throws Exception {
		ClassicEngineBoot.getInstance().start();
		String path = rutaReportes + nombreReporte;
		File f = new File(path);
		URL reportDefinition = f.toURI().toURL();

		ByteArrayOutputStream byteArray = null;
		try {
			ResourceManager manager = new ResourceManager();
			manager.registerDefaults();
			Resource res = manager.createDirectly(reportDefinition, MasterReport.class);
			MasterReport reporte = (MasterReport) res.getResource();

			if (parametrosReporte != null) {
				String safilocaleCliente = "safilocale.cliente";
				String safilocaleCtaAhorro = "safilocale.ctaAhorro";
				String fechaSistema = String.valueOf(ParametrosSessionControlador.parametrosSesionBean.getFechaAplicacion() + "");
				safilocaleCliente = Utileria.generaLocale(safilocaleCliente, ParametrosSessionControlador.parametrosSesionBean.getNomCortoInstitucion());
				safilocaleCtaAhorro = Utileria.generaLocale(safilocaleCtaAhorro, ParametrosSessionControlador.parametrosSesionBean.getNomCortoInstitucion());
				parametrosReporte.agregaParametro("Par_FechaSistema", fechaSistema);
				parametrosReporte.agregaParametro("Par_RutaImagen", rutaImgReportes);
				parametrosReporte.agregaParametro("Par_SafiLocale", safilocaleCliente);
				parametrosReporte.agregaParametro("Par_SafiLocaleCta", safilocaleCtaAhorro);
				agregraParametros(reporte, parametrosReporte);
			}
			byteArray = new ByteArrayOutputStream();
			PdfReportUtil.createPDF(reporte, byteArray);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return byteArray;
	}

}
