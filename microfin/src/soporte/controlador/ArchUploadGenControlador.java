package soporte.controlador;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import general.bean.MensajeTransaccionArchivoBean;
import herramientas.Utileria;
import soporte.bean.ArchUploadGenBean;
import soporte.servicio.ArchUploadGenServicio;
/**
 * Controlador para la pantalla de subida de archivos.
 * @author pmontero
 *
 */
public class ArchUploadGenControlador extends SimpleFormController {
	ArchUploadGenServicio archUploadGenServicio = null;

	public ArchUploadGenControlador() {
		setCommandClass(ArchUploadGenBean.class);
		setCommandName("archUploadGenBean");
	}

	public static interface Enum_Tra_Upload {
		int	condonacionMasiva	= 1;
		int	castigoMasivo		= 2;
	}

	public static interface Enum_Path_Upload {
		String	condonacionMasiva	= "CONDONACIONMAS";
		String	castigoMasivo		= "CASTIGOMAS";
	}

	protected ModelAndView onSubmit(HttpServletRequest request, HttpServletResponse response, Object command, BindException errors) throws ServletException, IOException {
		ArchUploadGenBean bean = (ArchUploadGenBean) command;
		MensajeTransaccionArchivoBean mensaje = null;
		int tipo = Utileria.convierteEntero(bean.getTipo());
		switch (tipo) {
		case Enum_Tra_Upload.condonacionMasiva:
			mensaje = archUploadGenServicio.condonacionUpload(bean);
			break;
		case Enum_Tra_Upload.castigoMasivo:
			mensaje = archUploadGenServicio.castigoUpload(bean);
			break;
		default:
			mensaje=new MensajeTransaccionArchivoBean();
			mensaje.setNumero(999);
			mensaje.setDescripcion("No Existe el Tipo de Transacción.");
			break;
		}

		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	public ArchUploadGenServicio getArchUploadGenServicio() {
		return archUploadGenServicio;
	}

	public void setArchUploadGenServicio(ArchUploadGenServicio archUploadGenServicio) {
		this.archUploadGenServicio = archUploadGenServicio;
	}

}
