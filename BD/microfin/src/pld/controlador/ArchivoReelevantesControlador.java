package pld.controlador;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.util.List;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import pld.bean.ArchivoReelevantesBean;
import pld.bean.ReporteReelevantesBean;
import pld.servicio.ArchivoReelevantesServicio;
import soporte.bean.ParametrosSisBean;
import soporte.servicio.ParametrosSisServicio;
import soporte.servicio.ParametrosSisServicio.Enum_Con_ParametrosSis;



public class ArchivoReelevantesControlador extends AbstractCommandController {

	ParametrosSisServicio parametrosSisServicio = null;

	public ArchivoReelevantesControlador(){
		setCommandClass(ReporteReelevantesBean.class);
		setCommandName("ReelevantesCNBV");
	}

	ArchivoReelevantesServicio archivoReelevantesServicio = null;

	@Override
	protected ModelAndView handle(HttpServletRequest request,
								HttpServletResponse response,
								Object command,
								BindException errors) throws Exception {

		ReporteReelevantesBean reporteReelevantesBean = (ReporteReelevantesBean) command;
		String contentOriginal = response.getContentType();
		String archivoSal= "";

		try{
			/* Se obtiene la ruta de archivos PLD que se encuentra en el servidor */
			ParametrosSisBean parametrosSisBean = new ParametrosSisBean();
			parametrosSisBean.setEmpresaID("1");
			parametrosSisBean = parametrosSisServicio.consulta(Enum_Con_ParametrosSis.principal, parametrosSisBean);

			/* Se obtiene la ruta del archivo reporte alojado en el servidor. */
			archivoSal = parametrosSisBean.getRutaArchivosPLD().trim()+reporteReelevantesBean.getArchivo().trim();

			File archivoFile = new File(archivoSal);
			FileInputStream fileInputStream = new FileInputStream(archivoFile);

			// no cambiar el  attachment por inline en este archivo, porque asi se utiliza
			response.addHeader("Content-Disposition", "attachment; filename=" + reporteReelevantesBean.getArchivo().trim());
			response.setContentType(contentOriginal);

			response.setContentLength((int) archivoFile.length());
			int bytes;

			while ((bytes = fileInputStream.read()) != -1) {
				response.getOutputStream().write(bytes);
			}

			response.getOutputStream().flush();
			response.getOutputStream().close();
			
		} catch (IOException io){
			io.printStackTrace();
		}

		return null;
	}

	public ArchivoReelevantesServicio getArchivoReelevantesServicio() {
		return archivoReelevantesServicio;
	}

	public void setArchivoReelevantesServicio(
			ArchivoReelevantesServicio archivoReelevantesServicio) {
		this.archivoReelevantesServicio = archivoReelevantesServicio;
	}

	public ParametrosSisServicio getParametrosSisServicio() {
		return parametrosSisServicio;
	}

	public void setParametrosSisServicio(ParametrosSisServicio parametrosSisServicio) {
		this.parametrosSisServicio = parametrosSisServicio;
	}

}