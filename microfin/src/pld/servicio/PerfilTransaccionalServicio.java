package pld.servicio;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

import java.util.ArrayList;
import java.util.List;
import java.util.StringTokenizer;

import javax.servlet.http.HttpServletResponse;

import pld.bean.PerfilTransaccionalBean;
import pld.dao.PerfilTransaccionalDAO;

public class PerfilTransaccionalServicio extends BaseServicio {
	PerfilTransaccionalDAO	perfilTransaccionalDAO;

	public static interface Enum_Tran_PerfilTransaccional {
		int	alta			= 1;
		int	modificacion	= 2;
		int actualizacion	= 3;
	}

	public static interface Enum_Con_PerfilTransaccional {
		int	principalCliente = 1;	// principal cliente.
		int prinUsrServicios = 3;	// principal usuario de servicios.
	}

	public static interface Enum_Lis_PerfilTransaccional {
		int	historicaCliente = 1;
		int	autorizacion	 = 2;
		int historicaUsuario = 3;
	}

	public static interface Enum_Com_PerfilTransaccional {
		int	listaComboOrigenRec	= 1;
		int	listaComboDestRec	= 2;

	}

	public static interface Enum_Lis_RepPerfilTransac {
		int	principal		= 1;
		int	autPerfilTransaccional	= 2;
	}


	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, PerfilTransaccionalBean bean) {
		MensajeTransaccionBean mensaje = null;
		try {
			switch (tipoTransaccion) {
				case Enum_Tran_PerfilTransaccional.alta :
					mensaje = perfilTransaccionalDAO.graba(bean);
					break;
				case Enum_Tran_PerfilTransaccional.modificacion :
					mensaje = perfilTransaccionalDAO.modifica(bean);
					break;
				case Enum_Tran_PerfilTransaccional.actualizacion :
					mensaje = perfilTransaccionalDAO.actualizacion(listaDetalles(bean.getDetalles()),tipoTransaccion );
					break;
			}
		} catch (Exception ex) {
			ex.printStackTrace();
		}
		return mensaje;
	}

	public PerfilTransaccionalBean consulta(PerfilTransaccionalBean bean, int tipoConsulta) {
		PerfilTransaccionalBean bean2 = null;
		switch (tipoConsulta) {
			case Enum_Con_PerfilTransaccional.principalCliente :
				bean2 = perfilTransaccionalDAO.consultaPrincipalCliente(bean, tipoConsulta);
			break;
			case Enum_Con_PerfilTransaccional.prinUsrServicios :
				bean2 = perfilTransaccionalDAO.consultaPrincipalUsuario(bean, tipoConsulta);
			break;
		}
		return bean2;
	}

	public List<PerfilTransaccionalBean> lista(int tipoLista, PerfilTransaccionalBean bean) {
		List<PerfilTransaccionalBean> lista = null;
		switch (tipoLista) {
			case Enum_Lis_PerfilTransaccional.historicaCliente :
				lista = perfilTransaccionalDAO.listaHistoricaCliente(bean, tipoLista);
			break;
			case Enum_Lis_PerfilTransaccional.autorizacion :
				lista = perfilTransaccionalDAO.listaAut(bean, tipoLista);
			break;
			case Enum_Lis_PerfilTransaccional.historicaUsuario :
				lista = perfilTransaccionalDAO.listaHistoricaUsuario(bean, tipoLista);
			break;
		}
		return lista;
	}

	public List<PerfilTransaccionalBean> listaReporte(int tipoLista, PerfilTransaccionalBean bean) {
		List<PerfilTransaccionalBean> lista = null;
		switch (tipoLista) {
		case Enum_Lis_RepPerfilTransac.principal :
		lista = perfilTransaccionalDAO.listaReporte(bean, tipoLista);
		break;
		case Enum_Lis_RepPerfilTransac.autPerfilTransaccional :
			lista = perfilTransaccionalDAO.repPerfilTransaccional(bean, tipoLista);
		break;
		}
		return lista;
	}

	public  Object[] listaComboOrigenRec(int tipoLista) {
		List lista = null;

		switch (tipoLista) {
			case Enum_Com_PerfilTransaccional.listaComboOrigenRec :
				lista = perfilTransaccionalDAO.listaComboOrigenRec(tipoLista);
				break;
		}
		return lista.toArray();
	}

	public  Object[] listaComboDestRec(int tipoLista) {
		List lista = null;

		switch (tipoLista) {
			case Enum_Com_PerfilTransaccional.listaComboDestRec :
				lista = perfilTransaccionalDAO.listaComboDestinoRec(tipoLista);
				break;
		}
		return lista.toArray();
	}

	public List<PerfilTransaccionalBean> listaDetalles(String detalle) {
		try {
			List<PerfilTransaccionalBean> listaDetalle = new ArrayList<PerfilTransaccionalBean>();
			StringTokenizer tokensBean = new StringTokenizer(detalle, "[");
			String stringCampos;
			String tokensCampos[];
			while (tokensBean.hasMoreTokens()) {
				PerfilTransaccionalBean conf = new PerfilTransaccionalBean();
				stringCampos = tokensBean.nextToken();
				tokensCampos = herramientas.Utileria.divideString(stringCampos, "]");
				conf.setClienteID(tokensCampos[0]);
				conf.setFecha(tokensCampos[1]);
				conf.setEstatus(tokensCampos[2]);
				listaDetalle.add(conf);
			}
			return listaDetalle;
		} catch (Exception ex) {
			ex.printStackTrace();
		}
		return null;
	}


	public PerfilTransaccionalDAO getPerfilTransaccionalDAO() {
		return perfilTransaccionalDAO;
	}

	public void setPerfilTransaccionalDAO(PerfilTransaccionalDAO perfilTransaccionalDAO) {
		this.perfilTransaccionalDAO = perfilTransaccionalDAO;
	}

}
