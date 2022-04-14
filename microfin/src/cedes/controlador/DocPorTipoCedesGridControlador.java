package cedes.controlador;


	import java.util.ArrayList;
	import java.util.List;

	import javax.servlet.http.HttpServletRequest;
	import javax.servlet.http.HttpServletResponse;

	import org.springframework.validation.BindException;
	import org.springframework.web.servlet.ModelAndView;
	import org.springframework.web.servlet.mvc.AbstractCommandController;

	import cedes.bean.DocPorTipoCedesBean;
	import cedes.servicio.DocPorTipoCedesServicio;


	public class DocPorTipoCedesGridControlador extends AbstractCommandController{
		
		DocPorTipoCedesServicio docPorTipoCedesServicio  = null;
		
	public DocPorTipoCedesGridControlador() {
		setCommandClass(DocPorTipoCedesBean.class);
		setCommandName("docPorTipoCedes");
	}

	protected ModelAndView handle(HttpServletRequest request,
								  HttpServletResponse response,
								  Object command,
								  BindException errors) throws Exception {	
		DocPorTipoCedesBean docPorTipoCedesBean = (DocPorTipoCedesBean) command;
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		List documentosReqList = docPorTipoCedesServicio.lista(tipoLista, docPorTipoCedesBean);
		List listaResultado = new ArrayList();
		listaResultado.add(tipoLista);
		listaResultado.add(documentosReqList);
		
		return new ModelAndView("cedes/docPorTipoCedesGridVista", "listaResultado", listaResultado);
	}

	public void setDocPorTipoCedesServicio(DocPorTipoCedesServicio docPorTipoCedesServicio) {
		this.docPorTipoCedesServicio = docPorTipoCedesServicio;
	}
 

	}





