package cliente.controlador; 

 import java.util.ArrayList;
 import java.util.List;
 import javax.servlet.http.HttpServletRequest;
 import javax.servlet.http.HttpServletResponse;

 import org.springframework.validation.BindException;
 import org.springframework.web.servlet.ModelAndView;
 import org.springframework.web.servlet.mvc.AbstractCommandController;

 import cliente.bean.ClientesCancelaBean;
 import cliente.servicio.ClientesCancelaServicio;

 public class ClientesCancelaListaControlador extends AbstractCommandController {

 	ClientesCancelaServicio clientesCancelaServicio = null;

 	public ClientesCancelaListaControlador(){
 		setCommandClass(ClientesCancelaBean.class);
 		setCommandName("clientesCancelaBean");
 	}

	protected ModelAndView handle(HttpServletRequest request,
			  HttpServletResponse response,
			  Object command,
			  BindException errors) throws Exception {

 		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
        String controlID = request.getParameter("controlID");
        
        ClientesCancelaBean clientesCancelaBean = (ClientesCancelaBean) command;
         List clientesCancela = clientesCancelaServicio.lista(tipoLista, clientesCancelaBean);
         
         List listaResultado = (List)new ArrayList();
         listaResultado.add(tipoLista);
         listaResultado.add(controlID);
         listaResultado.add(clientesCancela);
 		return new ModelAndView("cliente/clientesCancelaListaVista", "listaResultado", listaResultado);
 	}

	public ClientesCancelaServicio getClientesCancelaServicio() {
		return clientesCancelaServicio;
	}

	public void setClientesCancelaServicio(
			ClientesCancelaServicio clientesCancelaServicio) {
		this.clientesCancelaServicio = clientesCancelaServicio;
	}

 	
 } 
