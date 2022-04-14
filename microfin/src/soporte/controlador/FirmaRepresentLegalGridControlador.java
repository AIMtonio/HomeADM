package soporte.controlador;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import soporte.bean.FirmaRepresentLegalBean;
import soporte.servicio.FirmaRepresentLegalServicio;

public class FirmaRepresentLegalGridControlador extends AbstractCommandController{
		FirmaRepresentLegalServicio firmaRepresentLegalServicio=null;
		
		public FirmaRepresentLegalGridControlador(){
			setCommandClass(FirmaRepresentLegalBean.class);
			setCommandName("firmasGrid");
		}
		
		protected ModelAndView handle(HttpServletRequest request,HttpServletResponse response,
				  											Object command,BindException errors) throws Exception {
			
			FirmaRepresentLegalBean firmaBean= (FirmaRepresentLegalBean) command;
			int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
			List firmaArchivoLista = firmaRepresentLegalServicio.listaFirmasGrid(tipoLista,firmaBean);			
			return new ModelAndView("soporte/firmaRepresentLegalGrid","firmaArchivo",firmaArchivoLista);
		}

		public FirmaRepresentLegalServicio getFirmaRepresentLegalServicio() {
			return firmaRepresentLegalServicio;
		}
		public void setFirmaRepresentLegalServicio(
				FirmaRepresentLegalServicio firmaRepresentLegalServicio) {
			this.firmaRepresentLegalServicio = firmaRepresentLegalServicio;
		}
}
