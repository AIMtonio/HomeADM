package cliente.controlador;

import java.util.ArrayList;
import java.util.List;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;
import cliente.bean.TiposIdentiBean;
import cliente.servicio.TiposIdentiServicio;

public class TiposIdentiListaControlador extends AbstractCommandController {

	TiposIdentiServicio tiposIdentiServicio = null;

	public TiposIdentiListaControlador(){
		setCommandClass(TiposIdentiBean.class);
		setCommandName("tiposIdentificacion");
	}

	protected ModelAndView handle(HttpServletRequest request,
									HttpServletResponse response,
									Object command,
									BindException errors) throws Exception {

		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
        String controlID = request.getParameter("controlID");
             
        TiposIdentiBean tiposIdenti = (TiposIdentiBean) command;
        List tiposIdentificacion = tiposIdentiServicio.lista(tipoLista,tiposIdenti);
               
        List listaResultado = (List)new ArrayList();
        listaResultado.add(tipoLista);
        listaResultado.add(controlID);
        listaResultado.add(tiposIdentificacion);
        
        return new ModelAndView("cliente/tiposIdentiListaVista", "listaResultado", listaResultado);
		}

	public void setTiposIdentiServicio(TiposIdentiServicio tiposIdentiServicio){
                   this.tiposIdentiServicio = tiposIdentiServicio;
	}
} 