package pld.servicio;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

import java.util.List;

import pld.bean.ConocimientoUsuarioServiciosBean;
import pld.dao.ConocimientoUsuarioServiciosDAO;

public class ConocimientoUsuarioServiciosServicio extends BaseServicio {

	ConocimientoUsuarioServiciosDAO conocimientoUsuarioDAO = null;

	private ConocimientoUsuarioServiciosServicio() {
		super();
	}

	public static interface Enum_Transaccion {
		int alta = 1;
        int modificacion = 2;
	}

	public static interface Enum_Consulta {
		int principal = 1;
	}

	/**
	 * Método que graba la transacción.
	 * @param tipoTransaccion : Número del tipo transacción.
	 * @param conocimientoUsuarioBean : Datos del usuario de servicios
	 * @return MensajeTransaccionBean
	*/
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, ConocimientoUsuarioServiciosBean conocimientoUsuarioBean) {

        MensajeTransaccionBean mensaje = null;

		switch (tipoTransaccion) {
		    case Enum_Transaccion.alta:
			    mensaje = conocimientoUsuarioDAO.altaConocimiento(conocimientoUsuarioBean);
			break;
            case Enum_Transaccion.modificacion:
                mensaje = conocimientoUsuarioDAO.modificacionConocimiento(conocimientoUsuarioBean);
            break;
		}

		return mensaje;
	}

    /**
	 * Método para consultas del conocimiento del usuario de servicios.
	 * @param tipoConsulta : Número del tipo de consulta.
	 * @param conocimientoUsuarioBean : Datos del usuario de servicios
	 * @return ConocimientoUsuarioServiciosBean
	*/
    public ConocimientoUsuarioServiciosBean consulta(int tipoConsulta, ConocimientoUsuarioServiciosBean conocimientoUsuarioBean) {

        ConocimientoUsuarioServiciosBean conocimientoUsuario = null;

		switch (tipoConsulta) {
            case Enum_Consulta.principal:
                conocimientoUsuario = conocimientoUsuarioDAO.consultaPrincipal(tipoConsulta, conocimientoUsuarioBean);
            break;
        }

		return conocimientoUsuario;
	}

	public ConocimientoUsuarioServiciosDAO getConocimientoUsuarioServiciosDAO() {
		return conocimientoUsuarioDAO;
	}

	public void setConocimientoUsuarioServiciosDAO(ConocimientoUsuarioServiciosDAO conocimientoUsuarioDAO) {
		this.conocimientoUsuarioDAO = conocimientoUsuarioDAO;
	}
}