package aportaciones.servicio;

import java.util.ArrayList;
import java.util.List;
import java.util.StringTokenizer;

import javax.servlet.http.HttpServletResponse;

import aportaciones.bean.AportDispersionesBean;
import aportaciones.bean.AportacionesBean;
import aportaciones.dao.AportDispersionesDAO;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import herramientas.Utileria;

public class AportDispersionesServicio extends BaseServicio{

	AportDispersionesDAO aportDispersionesDAO = null;

	//---------- Constructor ------------------------------------------------------------------------
	public AportDispersionesServicio(){
		super();
	}


	public static interface Enum_Tra_AportDispersiones{
		int altaBenef	    = 1;
		int actElegidos		= 2;
		int procesarDisp	= 3;
		int exportaDisp		= 4;
		int cancelaDisp		= 5;
	}

	public static interface Enum_Con_AportDispersiones {
		int principal 		= 1;
		int foranea			= 2;
		int anclaje         = 3;
		int anclajeHijo     = 4;
	}

	public static interface Enum_Lis_AportDispersiones {
		int dispersiones		= 1;
		int beneficiarios		= 3;
		int dispProcesadasRep	= 4;
	}

	public static interface Enum_Exp_Dispersion {
		int interbancario   = 1;

	}

	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, AportDispersionesBean aportDispersionesBean){
		MensajeTransaccionBean mensaje = null;
		switch(tipoTransaccion){
		case(Enum_Tra_AportDispersiones.altaBenef):
			mensaje = grabaDetalle(tipoTransaccion, aportDispersionesBean, null);
		break;
		case(Enum_Tra_AportDispersiones.actElegidos):
			mensaje = grabaDetalleAp(tipoTransaccion, aportDispersionesBean, null);
		break;
		case(Enum_Tra_AportDispersiones.procesarDisp):
			mensaje = grabaDetalleAp(tipoTransaccion, aportDispersionesBean, null);
		break;
		case(Enum_Tra_AportDispersiones.exportaDisp):
			mensaje = grabaDetalleAp(tipoTransaccion, aportDispersionesBean, null);
		break;
		case(Enum_Tra_AportDispersiones.cancelaDisp):
			mensaje = grabaDetalleAp(tipoTransaccion, aportDispersionesBean, null);
		break;
		
		}

		return mensaje;
	}

	public List<AportDispersionesBean> lista(int tipoLista, AportDispersionesBean aportDispersionesBean){
		List<AportDispersionesBean> grupo = null;
		switch (tipoLista) {
		case  Enum_Lis_AportDispersiones.dispersiones:
			grupo = aportDispersionesDAO.listaPrincipal(aportDispersionesBean, tipoLista);
			break;
		case  Enum_Lis_AportDispersiones.beneficiarios:
			grupo = aportDispersionesDAO.listaBeneficiarios(aportDispersionesBean, tipoLista);
			break;
		case  Enum_Lis_AportDispersiones.dispProcesadasRep:
			grupo = aportDispersionesDAO.listaReporte(aportDispersionesBean, tipoLista);
			break;
		}
		return grupo;
	}

	/**
	 * Graba la lista de los beneficiarios de las dispersiones.
	 * @param tipoTransaccion  tipo de transacción.
	 * @param apDispBean clase bean que contiene los valores para dar de baja y alta.
	 * @param detalles cadena con la lista de los beneficiarios a parsear en la clase bean.
	 * @return {@link MensajeTransaccionBean} clase bean con el resultado de la transacción.
	 * @author avelasco
	 **/
	private MensajeTransaccionBean grabaDetalle(int tipoTransaccion, AportDispersionesBean apDispBean, String detalles) {
		MensajeTransaccionBean mensaje = null;
		detalles = apDispBean.getDetalleBenef();
		String tipoPersona = "T";
		int tipoAct = 0;
			try {
				 apDispBean = creaListaDetalle(apDispBean, detalles,tipoPersona);
				 List<AportDispersionesBean> listaDetalleB = apDispBean.getListaDetalle();
				 
				 for(AportDispersionesBean detalle : listaDetalleB){
					 tipoAct = Utileria.convierteEntero(detalle.getTipoTrans());
				 }
				 
				 if(tipoAct > 3){
					 switch(tipoAct){
						case(Enum_Tra_AportDispersiones.procesarDisp):
							mensaje=aportDispersionesDAO.dispersaAport(apDispBean, listaDetalleB, tipoAct);
						break;
						case(Enum_Tra_AportDispersiones.exportaDisp):
							mensaje=aportDispersionesDAO.exportaAport(apDispBean, listaDetalleB, tipoAct);
						break;
						case(Enum_Tra_AportDispersiones.cancelaDisp):
							mensaje=aportDispersionesDAO.cancelaAport(apDispBean, listaDetalleB, tipoAct);
						break;
					}	 
				 }else{
					 if(tipoAct == 3){
						 mensaje = aportDispersionesDAO.procesaAportaciones(apDispBean,listaDetalleB,detalles,tipoAct);
						 if (mensaje.getNumero() != 0) {
							 throw new Exception(mensaje.getDescripcion());
						 }
					 }else{

						 mensaje=aportDispersionesDAO.grabaDetalle(apDispBean, listaDetalleB);

						 if (mensaje.getNumero() != 0) {
							 throw new Exception(mensaje.getDescripcion());
						 }
					 }
				 }
			} catch (Exception e) {
				if (mensaje.getNumero() == 0) {
					mensaje.setNumero(999);
				}
				mensaje.setDescripcion(e.getMessage());
				return mensaje;
			} 
			
		return mensaje;
	}
	/**
	 * Graba la lista de las dispersiones.
	 * @param tipoTransaccion  tipo de transacción.
	 * @param apDispBean clase bean que contiene los valores para dar de baja y alta.
	 * @param detalles cadena con la lista de las dispersiones a parsear en la clase bean.
	 * @return {@link MensajeTransaccionBean} clase bean con el resultado de la transacción.
	 * @author avelasco
	 */
	private MensajeTransaccionBean grabaDetalleAp(int tipoTransaccion, AportDispersionesBean apDispBean, String detalles) {
		MensajeTransaccionBean mensaje = null;
		detalles = apDispBean.getDetalleAport();
		String tipoPersona = "T";
		try{
			apDispBean = creaListaDetalle(apDispBean, detalles,tipoPersona);
			List<AportDispersionesBean> listaDetalle = apDispBean.getListaDetalle();

			switch(tipoTransaccion){
				case(Enum_Tra_AportDispersiones.actElegidos):
					mensaje=aportDispersionesDAO.actualizaEstatus(apDispBean, listaDetalle, tipoTransaccion);
				break;
				case(Enum_Tra_AportDispersiones.procesarDisp):
					mensaje=aportDispersionesDAO.dispersaAport(apDispBean, listaDetalle, tipoTransaccion);
				break;
				case(Enum_Tra_AportDispersiones.exportaDisp):
					mensaje=aportDispersionesDAO.exportaAport(apDispBean, listaDetalle, tipoTransaccion);
				break;
				case(Enum_Tra_AportDispersiones.cancelaDisp):
					mensaje=aportDispersionesDAO.cancelaAport(apDispBean, listaDetalle, tipoTransaccion);
				break;
			}
		} catch (Exception e){
			e.printStackTrace();
			return null;
		}
		return mensaje;
	}

	/**
	 * Método para crear la lista de los beneficiarios de dispersiones.
	 * @param apDispBean clase bean en el que se setean el número de la aportación y de la amortización. 
	 * @param detalles Cadena de la lista separados por corchetes.
	 * @return List  Lista con los beans que contiene los datos de los beneficiarios.
	 * @author avelasco
	 */
	private AportDispersionesBean creaListaDetalle(AportDispersionesBean apDispBean, String detalles, String tipoPersona) {
		StringTokenizer tokensBean = new StringTokenizer(detalles, "[");
		String stringCampos;
		String tokensCampos[];
		String tokenPersona;
		List<AportDispersionesBean> listaDetalle = new ArrayList<AportDispersionesBean>();
		AportDispersionesBean detalle;
		try {
			while (tokensBean.hasMoreTokens()) {
				detalle = new AportDispersionesBean();
				stringCampos = tokensBean.nextToken();

				tokensCampos = herramientas.Utileria.divideString(stringCampos, "]");
				detalle.setAportacionID(tokensCampos[0]);
				detalle.setAmortizacionID(tokensCampos[1]);
				detalle.setCuentaTranID(tokensCampos[2]);
				detalle.setInstitucionID(tokensCampos[3]);
				detalle.setTipoCuentaID(tokensCampos[4]);
				detalle.setClabe(tokensCampos[5]);
				detalle.setBeneficiario(tokensCampos[6]);
				detalle.setMonto(tokensCampos[7]);
				detalle.setEsPrincipal(tokensCampos[8]);
				detalle.setTotal(tokensCampos[9]);
				detalle.setEstatus(tokensCampos[10]);
				detalle.setTipoPersona(tokensCampos[11]);
				detalle.setTipoTrans(tokensCampos[12]);
				tokenPersona = detalle.getTipoPersona(); 
				if(tokenPersona.equalsIgnoreCase(tipoPersona) || tipoPersona.equalsIgnoreCase("T") ){
					listaDetalle.add(detalle);
				}

				apDispBean.setAportacionID(detalle.getAportacionID());
				apDispBean.setAmortizacionID(detalle.getAmortizacionID());
			}
		} catch (Exception e){
			e.printStackTrace();
		}

		apDispBean.setListaDetalle(listaDetalle);

		return apDispBean;
	}

	/**
	 * Método para crear la lista de dispersiones.
	 * @param apDispBean clase bean en el que se setean el número de la aportación y de la amortización. 
	 * @param detalles Cadena de la lista separados por corchetes.
	 * @return List  Lista con los beans que contiene los datos de las dispersiones.
	 * @author avelasco
	 */
	private AportDispersionesBean creaListaDetalleAp(AportDispersionesBean apDispBean, String detalles) {
		StringTokenizer tokensBean = new StringTokenizer(detalles, "[");
		String stringCampos;
		String tokensCampos[];
		List<AportDispersionesBean> listaDetalle = new ArrayList<AportDispersionesBean>();
		AportDispersionesBean detalle;
		try {
			while (tokensBean.hasMoreTokens()) {
				detalle = new AportDispersionesBean();
				stringCampos = tokensBean.nextToken();

				tokensCampos = herramientas.Utileria.divideString(stringCampos, "]");
				detalle.setAportacionID(tokensCampos[0]);
				detalle.setAmortizacionID(tokensCampos[1]);
				detalle.setEstatus(tokensCampos[2]);
				listaDetalle.add(detalle);
			}
		} catch (Exception e){
			e.printStackTrace();
		}
		apDispBean.setListaDetalle(listaDetalle);

		return apDispBean;
	}
	
	/* Exportar archivo de Dipersion Interbancario de Aportaciones */
	public List obtieneLayaoutDispersionInter(int consecutivo){
		
		List <AportDispersionesBean> listaRegistros = null;
		List <AportDispersionesBean> lista = new ArrayList();

		AportDispersionesBean dispersion = null;
		
		listaRegistros = aportDispersionesDAO.consultaDatosDispersionInter(consecutivo, Enum_Exp_Dispersion.interbancario);

		for (AportDispersionesBean listaDispersion: listaRegistros){
			
			dispersion = new AportDispersionesBean();
			
			dispersion.setCuentaDestino(listaDispersion.getCuentaDestino()); 
			dispersion.setNumCtaInstit(listaDispersion.getNumCtaInstit());
			dispersion.setMonto(listaDispersion.getMonto());
			dispersion.setNombreBeneficiario(listaDispersion.getNombreBeneficiario());
			dispersion.setFolio(listaDispersion.getFolio());
			dispersion.setDescripcion(listaDispersion.getDescripcion());
			dispersion.setReferencia(listaDispersion.getReferencia());
			dispersion.setTipoCuentaID(listaDispersion.getTipoCuentaID());
			
			lista.add(dispersion);
		}
		return lista;
	}

	public AportDispersionesDAO getAportDispersionesDAO() {
		return aportDispersionesDAO;
	}

	public void setAportDispersionesDAO(AportDispersionesDAO aportDispersionesDAO) {
		this.aportDispersionesDAO = aportDispersionesDAO;
	}
}