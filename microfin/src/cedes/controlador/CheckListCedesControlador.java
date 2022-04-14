package cedes.controlador;

	import general.bean.MensajeTransaccionBean;

	import javax.servlet.http.HttpServletRequest;
	import javax.servlet.http.HttpServletResponse;

	import org.springframework.validation.BindException;
	import org.springframework.web.servlet.ModelAndView;
	import org.springframework.web.servlet.mvc.SimpleFormController;

	import cedes.bean.CheckListCedesBean;
	import cedes.servicio.CheckListCedesServicio;


	public class CheckListCedesControlador extends SimpleFormController {

		CheckListCedesServicio	checkListCedesServicio=null;

		public CheckListCedesControlador(){
			setCommandClass(CheckListCedesBean.class);
			setCommandName("checkListCedes");
		}

		protected ModelAndView onSubmit(HttpServletRequest request,
										HttpServletResponse response,
										Object command,
										BindException errors) throws Exception {

			CheckListCedesBean checkListCedesBean = (CheckListCedesBean) command;
			
			checkListCedesServicio.getCheckListCedesDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
			
			
			int tipoTransaccion =(request.getParameter("tipoTransaccion")!=null)?
					Integer.parseInt(request.getParameter("tipoTransaccion")):
					0;
			
			String datosGrid = request.getParameter("datosGrid");	
			MensajeTransaccionBean mensaje = null;
			mensaje = checkListCedesServicio.grabaTransaccion(tipoTransaccion, checkListCedesBean,datosGrid);
			return new ModelAndView(getSuccessView(), "mensaje", mensaje);
		}
 
		public CheckListCedesServicio getCheckListCedesServicio() {
			return checkListCedesServicio;
		}

		public void setCheckListCedesServicio(
				CheckListCedesServicio checkListCedesServicio) {
			this.checkListCedesServicio = checkListCedesServicio;
		}

		

		
		
		
	} 



