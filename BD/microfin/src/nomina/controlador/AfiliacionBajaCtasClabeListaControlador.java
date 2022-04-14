package nomina.controlador;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.support.PagedListHolder;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import herramientas.Utileria;
import mondrian.test.loader.CsvDBLoader.ListRowStream;
import nomina.bean.AfiliacionBajaCtasClabeBean;
import nomina.servicio.AfiliacionBajaCtasClabeServicio;

public class AfiliacionBajaCtasClabeListaControlador  extends AbstractCommandController {
	//InstitucionNominaServicio institucionNominaServicio = null;
		AfiliacionBajaCtasClabeServicio afiliacionBajaCtasClabeServicio = null;
		
		public static interface Enum_Lis_Mostrar{
			int listaAfiliacion = 4;
		}
		
		public AfiliacionBajaCtasClabeListaControlador(){
			setCommandClass(AfiliacionBajaCtasClabeBean.class);
			//setCommandName("afiliacionBajaCtasClabe");
		}
		@Override
		protected ModelAndView handle(HttpServletRequest request,
				  HttpServletResponse response,
				  Object command,
				  BindException errors) throws Exception {
			
			int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
			String controlID = request.getParameter("controlID");
			
			
			
			List listaValores = null;
			List listaResultado = new ArrayList();
			switch(tipoLista){
				case Enum_Lis_Mostrar.listaAfiliacion:
					AfiliacionBajaCtasClabeBean afiliacionBajaCtasClabeBean = (AfiliacionBajaCtasClabeBean) command;
					listaValores = afiliacionBajaCtasClabeServicio.lista(tipoLista, afiliacionBajaCtasClabeBean);
					break;
							
			}
			listaResultado.add(tipoLista);
			listaResultado.add(controlID);
			listaResultado.add(listaValores);
			
		return new ModelAndView("nomina/afiliacionBajaCtasClabeListaVista", "listaResultado", listaResultado);
		}
		
		public AfiliacionBajaCtasClabeServicio getAfiliacionBajaCtasClabeServicio() {
			return afiliacionBajaCtasClabeServicio;
		}
		public void setAfiliacionBajaCtasClabeServicio(AfiliacionBajaCtasClabeServicio afiliacionBajaCtasClabeServicio) {
			this.afiliacionBajaCtasClabeServicio = afiliacionBajaCtasClabeServicio;
		}
		
}
