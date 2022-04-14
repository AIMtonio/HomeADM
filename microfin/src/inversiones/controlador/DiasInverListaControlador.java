/*package inversiones.controlador; 

  import java.util.ArrayList;
  import java.util.List;
 import javax.servlet.http.HttpServletRequest;
 import javax.servlet.http.HttpServletResponse;

 import general.bean.MensajeTransaccionBean;

 import org.springframework.validation.BindException;
 import org.springframework.web.servlet.ModelAndView;
 import org.springframework.web.servlet.mvc.SimpleFormController;

 import inversiones.bean.DiasInversion;
 import inversiones.servicio.DiasInverServicio;

 public class DiasInverListaControlador extends SimpleFormController {

 	DiasInverServicio diasInverServicio = null;

 	public DiasInverListaControlador(){
 		setCommandClass(DiasInversion.class);
 		setCommandName("diasInversion");
 	}

 	protected ModelAndView onSubmit(HttpServletRequest request,
 					HttpServletResponse response,
 					Object command,
 					BindException errors) throws Exception {

 		DiasInversion diasInversion = (DiasInversion) command;

 		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
                 String controlID = request.getParameter("controlID");
                 DiasInversion diasInver = (DiasInversion) command;
                 List diasInver = diasInverServicio.lista(tipoLista, diasInver);
                 List listaResultado = (List)new ArrayList();
                 listaResultado.add(tipoLista);
                 listaResultado.add(controlID);
                 listaResultado.add(diasInver);
 		return new ModelAndView("diasInverListaVista", "listaResultado", listaResultado));
 	}

 	public void setDiasInverServicio(DiasInverServicio diasInverServicio){
                     this.diasInverServicio = diasInverServicio;
 	}
 } 
*/