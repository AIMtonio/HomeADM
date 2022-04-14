package aportaciones.servicio;

import java.util.List;
import java.util.ArrayList;
import java.util.StringTokenizer;

import aportaciones.bean.AportacionesBean;
import aportaciones.dao.CondicionesVencimDAO;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

public class CondicionesVencimServicio extends BaseServicio{
	CondicionesVencimDAO condicionesVencimDAO = null;

	public CondicionesVencimServicio () {
		super();
	}

	public static interface Enum_CondicionesVencimiento {
		int alta			 = 1;
		int modifica		 = 2;
		int actualizaEstatus = 3;
		int autoriza 		 = 4;
		int consolidacion	 = 5;
	}

	public static interface Enum_Con_CondicionesVencimiento {
		int principal		= 1;
		int existe			= 2;
		int estatus			= 3;
	}

	public static interface Enum_Lis_CondicionesVencimiento {
		int consolidaAport = 1;
	}

	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, AportacionesBean aportacionesBean){


		MensajeTransaccionBean mensaje = null;

		switch (tipoTransaccion) {
		case Enum_CondicionesVencimiento.alta:
			mensaje = condicionesVencimDAO.alta(aportacionesBean, tipoTransaccion);
		break;
		case Enum_CondicionesVencimiento.modifica:
			mensaje = condicionesVencimDAO.modificar(aportacionesBean, tipoTransaccion);
		break;
		case Enum_CondicionesVencimiento.actualizaEstatus:
			mensaje = condicionesVencimDAO.actualizarEstatus(aportacionesBean, tipoTransaccion);
		break;
		case Enum_CondicionesVencimiento.consolidacion:
			mensaje = grabaDetalle(tipoTransaccion, aportacionesBean, null);
		break;
		}

		return mensaje;
	}

	public AportacionesBean consulta(int tipoConsulta,AportacionesBean aportacionesBean){
		AportacionesBean aportaciones = null;
		switch (tipoConsulta) {
		case Enum_Con_CondicionesVencimiento.principal:
			aportaciones = condicionesVencimDAO.consultaPrincipal(aportacionesBean, Enum_Con_CondicionesVencimiento.principal);
			break;
		case Enum_Con_CondicionesVencimiento.existe:
			aportaciones = condicionesVencimDAO.consultaExiste(aportacionesBean, Enum_Con_CondicionesVencimiento.existe);
			break;
		case Enum_Con_CondicionesVencimiento.estatus:
			aportaciones = condicionesVencimDAO.consultaEstatus(aportacionesBean, Enum_Con_CondicionesVencimiento.estatus);
			break;
		}
		return aportaciones;
	}

	public List<AportacionesBean> lista(int tipoLista, AportacionesBean aportacionesBean){
		List<AportacionesBean> listaAport = null;
		switch (tipoLista) {
		case  Enum_Lis_CondicionesVencimiento.consolidaAport:
			listaAport = condicionesVencimDAO.listaConsolidaciones(aportacionesBean, tipoLista);
			break;
		}
		return listaAport;
	}

	private MensajeTransaccionBean grabaDetalle(int tipoTransaccion, AportacionesBean aportBean, String detalles) {
		MensajeTransaccionBean mensaje = null;
		try{
			detalles = aportBean.getDetalle();
			List<AportacionesBean> listaDetalle = creaListaDetalle(detalles);
			mensaje=condicionesVencimDAO.grabaDetalle(aportBean, listaDetalle);
		} catch (Exception e){
			e.printStackTrace();
			return null;
		}
		return mensaje;
	}

	private List<AportacionesBean> creaListaDetalle(String detalles) {
		StringTokenizer tokensBean = new StringTokenizer(detalles, "[");
		String stringCampos;
		String tokensCampos[];
		List<AportacionesBean> listaDetalle = new ArrayList<AportacionesBean>();
		AportacionesBean detalle;
		try {
			while (tokensBean.hasMoreTokens()) {
				detalle = new AportacionesBean();
				stringCampos = tokensBean.nextToken();

				tokensCampos = herramientas.Utileria.divideString(stringCampos, "]");
				detalle.setAportacionID(tokensCampos[0]);
				detalle.setAportConsolID(tokensCampos[1]);
				detalle.setFechaVencimiento(tokensCampos[2]);
				detalle.setMonto(tokensCampos[3]);
				detalle.setInteresGenerado(tokensCampos[4]);
				detalle.setInteresRetener(tokensCampos[5]);
				detalle.setTotalCapital(tokensCampos[6]);
				detalle.setReinvertir(tokensCampos[7]);
				detalle.setTotalFinal(tokensCampos[8]);

				listaDetalle.add(detalle);
			}
		} catch (Exception e){
			e.printStackTrace();
		}
		return listaDetalle;
	}

	public CondicionesVencimDAO getCondicionesVencimDAO() {
		return condicionesVencimDAO;
	}

	public void setCondicionesVencimDAO(CondicionesVencimDAO condicionesVencimDAO) {
		this.condicionesVencimDAO = condicionesVencimDAO;
	}
}