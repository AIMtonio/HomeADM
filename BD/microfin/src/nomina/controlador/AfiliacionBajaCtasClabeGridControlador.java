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

public class AfiliacionBajaCtasClabeGridControlador extends AbstractCommandController{

	AfiliacionBajaCtasClabeServicio afiliacionBajaCtasClabeServicio = null;
	
	public static interface Enum_Con_GridAfilia{
		int lista_Afiliada = 5;
		int lista_Sin_Afiliar  = 2; 
	}
	
	
	public AfiliacionBajaCtasClabeGridControlador(){
		setCommandClass(AfiliacionBajaCtasClabeBean.class);
		setCommandName("afiliacionBajaCtasClabe");
	}

	protected ModelAndView handle(HttpServletRequest request,
			  HttpServletResponse response,
			  Object command,
			  BindException errors) throws Exception {
		
		
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		String pagina = request.getParameter("pagina");
		String datoEliminado = request.getParameter("clienteEliminado");
		String tipoPaginacion ="";
		List listaResultado = new ArrayList();
		
		if(pagina == null){
			tipoPaginacion= "Completa";
		}

		List listaAfiliador = null;
		
		if(tipoPaginacion.equalsIgnoreCase("Completa")){
			AfiliacionBajaCtasClabeBean afiliacionBajaCtasClabeBean = (AfiliacionBajaCtasClabeBean) command;
			Date date = new Date();
			DateFormat fechaHora = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			afiliacionBajaCtasClabeBean.setFechaRegistro(fechaHora.format(date));
			

			
			switch(tipoLista){
				case Enum_Con_GridAfilia.lista_Afiliada:
					listaAfiliador = afiliacionBajaCtasClabeServicio.lista(tipoLista, afiliacionBajaCtasClabeBean);
					break;
				case Enum_Con_GridAfilia.lista_Sin_Afiliar:
					listaAfiliador = afiliacionBajaCtasClabeServicio.lista(tipoLista, afiliacionBajaCtasClabeBean);
					break;
			}
			
			PagedListHolder listaAfilia = new PagedListHolder(listaAfiliador);
			listaAfilia.setPageSize(20);
			listaResultado.add(0,listaAfilia);
			listaResultado.add(1,listaAfilia.getPage()+1);
			listaResultado.add(2,listaAfilia.getPageCount());
			listaResultado.add(3,listaAfiliador);
			request.getSession().setAttribute("listaAfilia", listaResultado);
			
		}else{
			PagedListHolder listaAfilia = null;
			AfiliacionBajaCtasClabeBean afiliacionBajaCtasClabeBean = (AfiliacionBajaCtasClabeBean) command;
			String[] listaComentario = request.getParameter("lisComentario").split(",");
			String[] listaClienteID = request.getParameter("lisClienteID").split(",");
			if (request.getSession().getAttribute("listaAfilia") != null) {
				listaResultado = (List) request.getSession().getAttribute("listaAfilia");
				listaAfilia = (PagedListHolder) listaResultado.get(0);
				/*Agregamos comentarios*/
				List listaTotal = listaAfilia.getSource();
				for(int i=0;i<listaTotal.size();i++){
					AfiliacionBajaCtasClabeBean afilia = (AfiliacionBajaCtasClabeBean)listaTotal.get(i);
					for(int j=0;j<listaComentario.length;j++){
						if(afilia.getClienteID().equalsIgnoreCase((String) listaClienteID[j])){
							afilia.setComentario((String)listaComentario[j]);
						}
						listaTotal.set(i, afilia);
					}
				}
				listaAfilia.setSource(listaTotal);
				
				if ("siguiente".equals(pagina)) {
					listaAfilia.nextPage();
				}
				else if ("anterior".equals(pagina)) {
					listaAfilia.previousPage();
					listaAfilia.getPage();
				}else if("primero".equals(pagina)){
					listaAfilia.setPage(0);
					listaAfilia.getPage();
				}else if("ultimo".equals(pagina)){
					listaAfilia.setPage(listaAfilia.getPageCount()-1);
					listaAfilia.getPage();
				}
				
				
				
				else if("elimina".equals(pagina)){

					List lista3 = listaAfilia.getSource();
					for(int i = 0 ; i<lista3.size(); i++){
						AfiliacionBajaCtasClabeBean afilia = (AfiliacionBajaCtasClabeBean)lista3.get(i);

						if(afilia.getClienteID().equalsIgnoreCase(datoEliminado)){
							lista3.remove(i);
						}						
					}
					listaAfilia.setSource(lista3);
					listaAfilia.setPageSize(20);
					listaResultado.add(0,listaAfilia);
					listaResultado.add(1,listaAfilia.getPage()+1);
					listaResultado.add(2,listaAfilia.getPageCount());
					listaResultado.add(3,lista3);
					request.getSession().setAttribute("listaAfilia", listaResultado);
					
				}
			} else {
				listaAfilia = null;
			}
			listaResultado.add(0, listaAfilia);
			listaResultado.add(1,listaAfilia.getPage()+1);
			listaResultado.add(2,listaAfilia.getPageCount());
		}
		
		
		return new ModelAndView("nomina/afiliacionBajaCtasClabeGrid","listaResultado",listaResultado);
		
	}
	public AfiliacionBajaCtasClabeServicio getAfiliacionBajaCtasClabeServicio() {
		return afiliacionBajaCtasClabeServicio;
	}
	public void setAfiliacionBajaCtasClabeServicio(AfiliacionBajaCtasClabeServicio afiliacionBajaCtasClabeServicio) {
		this.afiliacionBajaCtasClabeServicio = afiliacionBajaCtasClabeServicio;
	}
	

}
