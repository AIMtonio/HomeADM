package aportaciones.servicio;

import java.util.ArrayList;
import java.util.List;
import java.util.StringTokenizer;

import aportaciones.bean.GruposFamiliarBean;
import aportaciones.dao.GruposFamiliarDAO;
import cuentas.servicio.MonedasServicio;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

public class GruposFamiliarServicio extends BaseServicio{

	GruposFamiliarDAO gruposFamiliarDAO = null;

	//---------- Constructor ------------------------------------------------------------------------
	public GruposFamiliarServicio(){
		super();
	}


	public static interface Enum_Tra_GruposFamiliar{
		int alta				    = 1;
	}

	public static interface Enum_Con_GruposFamiliar {
		int principal 				= 1;
		int foranea					= 2;
		int anclaje                 = 3;
		int anclajeHijo             = 4;
	}

	public static interface Enum_Lis_GruposFamiliar {
		int general 	=1;
		int anclaje 	=2;
		int sinAnclaje	=3;
	}


	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, GruposFamiliarBean gruposFamiliarBean){
		MensajeTransaccionBean mensaje = null;
		switch(tipoTransaccion){
		case(Enum_Tra_GruposFamiliar.alta):
			mensaje = grabaDetalle(tipoTransaccion, gruposFamiliarBean, null);
		break;

		}

		return mensaje;
	}

	public GruposFamiliarBean consulta(int tipoConsulta, GruposFamiliarBean gruposFamiliarBean){
		GruposFamiliarBean aportacionesAnclaBean = null;
		switch(tipoConsulta){
		case(Enum_Con_GruposFamiliar.principal):
			aportacionesAnclaBean = gruposFamiliarDAO.consultaExistencia(gruposFamiliarBean, tipoConsulta);
		}
		return aportacionesAnclaBean;
	}

	public List<GruposFamiliarBean> lista(int tipoLista, GruposFamiliarBean gruposFamiliarBean){
		List<GruposFamiliarBean> grupo = null;
		switch (tipoLista) {
		case  Enum_Lis_GruposFamiliar.general:
			grupo = gruposFamiliarDAO.listaPrincipal(gruposFamiliarBean, tipoLista);
			break;
		}
		return grupo;
	}

	/**
	 * Graba la lista de los integrantes de un grupo familiar.
	 * @param tipoTransaccion  tipo de transacción, 1.- alta.
	 * @param grupoFamBean clase bean que contiene los valores para dar de baja y alta en el grupo.
	 * @param detalles cadena con la lista de los integrantes a parsear en la clase bean.
	 * @return {@link MensajeTransaccionBean} clase bean con el resultado de la transacción.
	 * @author avelasco
	 */
	private MensajeTransaccionBean grabaDetalle(int tipoTransaccion, GruposFamiliarBean grupoFamBean, String detalles) {
		MensajeTransaccionBean mensaje = null;
		detalles = grupoFamBean.getDetalle();
		try{
			List<GruposFamiliarBean> listaDetalle = creaListaDetalle(detalles);
			mensaje=gruposFamiliarDAO.grabaDetalle(grupoFamBean, listaDetalle);
		} catch (Exception e){
			e.printStackTrace();
			return null;
		}
		return mensaje;
	}

	/**
	 * Método para crear la lista de integrantes del gpo. familiar.
	 * @param detalles  Cadena de la lista separados por corchetes.
	 * @return List  Lista con los beans que contiene los datos de los integrantes.
	 * @author avelasco
	 */
	private List<GruposFamiliarBean> creaListaDetalle(String detalles) {
		StringTokenizer tokensBean = new StringTokenizer(detalles, "[");
		String stringCampos;
		String tokensCampos[];
		List<GruposFamiliarBean> listaDetalle = new ArrayList<GruposFamiliarBean>();
		GruposFamiliarBean detalle;
		try {
			while (tokensBean.hasMoreTokens()) {
				detalle = new GruposFamiliarBean();
				stringCampos = tokensBean.nextToken();

				tokensCampos = herramientas.Utileria.divideString(stringCampos, "]");
				detalle.setClienteID(tokensCampos[0]);
				detalle.setFamClienteID(tokensCampos[1]);
				detalle.setTipoRelacionID(tokensCampos[2]);

				listaDetalle.add(detalle);
			}
		} catch (Exception e){
			e.printStackTrace();
		}
		return listaDetalle;
	}

	public GruposFamiliarDAO getGruposFamiliarDAO() {
		return gruposFamiliarDAO;
	}

	public void setGruposFamiliarDAO(GruposFamiliarDAO gruposFamiliarDAO) {
		this.gruposFamiliarDAO = gruposFamiliarDAO;
	}

}