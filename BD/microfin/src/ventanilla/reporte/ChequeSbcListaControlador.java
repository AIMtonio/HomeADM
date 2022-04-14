package ventanilla.reporte;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import ventanilla.bean.AbonoChequeSBCBean;
import ventanilla.servicio.AbonoChequeSBCServicio;



public class ChequeSbcListaControlador extends AbstractCommandController  {

	AbonoChequeSBCServicio chequesSBC= null;

	public ChequeSbcListaControlador(){
 		setCommandClass(AbonoChequeSBCBean.class);
		setCommandName("abonoChequeSBCBean");
	}
	protected ModelAndView handle(HttpServletRequest request,
			  HttpServletResponse response,
			  Object command,
			  BindException errors) throws Exception {

 		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
        String controlID = request.getParameter("controlID");
        
        AbonoChequeSBCBean abonoChequeSBCBean = (AbonoChequeSBCBean) command;
        List listaCheques = chequesSBC.lista(tipoLista, abonoChequeSBCBean);
        
        List listaResultado = (List)new ArrayList();
        listaResultado.add(tipoLista);
        listaResultado.add(controlID);
        listaResultado.add(listaCheques);
        return new ModelAndView("ventanilla/chequeSbcListaVista", "listaResultado", listaResultado);
 	}
	
	public AbonoChequeSBCServicio getChequesSBC() {
		return chequesSBC;
	}
	public void setChequesSBC(AbonoChequeSBCServicio chequesSBC) {
		this.chequesSBC = chequesSBC;
	}
	
}