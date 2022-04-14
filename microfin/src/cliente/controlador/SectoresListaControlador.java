package cliente.controlador; 

  import java.util.ArrayList;
  import java.util.List;
 import javax.servlet.http.HttpServletRequest;
 import javax.servlet.http.HttpServletResponse;

 import general.bean.MensajeTransaccionBean;

 import org.springframework.validation.BindException;
 import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;


 import cliente.bean.SectoresBean;
import cliente.servicio.SectoresServicio;

 public class SectoresListaControlador extends AbstractCommandController {

 	SectoresServicio sectoresServicio = null;

 	public SectoresListaControlador(){
 		setCommandClass(SectoresBean.class);
 		setCommandName("sectores");
 	}

 	protected ModelAndView handle(HttpServletRequest request,
 								  HttpServletResponse response,
 								  Object command,
 								  BindException errors) throws Exception {


 		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
        String controlID = request.getParameter("controlID");
        
        SectoresBean sector = (SectoresBean) command;
        List sectores = sectoresServicio.lista(tipoLista, sector);
                 List listaResultado = (List)new ArrayList();
                 listaResultado.add(tipoLista);
                 listaResultado.add(controlID);
                 listaResultado.add(sectores);
 		return new ModelAndView("cliente/sectoresListaVista", "listaResultado", listaResultado);
 	}

 	public void setSectoresServicio(SectoresServicio sectoresServicio){
                     this.sectoresServicio = sectoresServicio;
 	}
 } 