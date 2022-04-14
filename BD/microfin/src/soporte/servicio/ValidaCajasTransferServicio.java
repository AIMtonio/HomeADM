package soporte.servicio;

import java.util.ArrayList;
import java.util.List;
import java.util.StringTokenizer;

import general.bean.MensajeTransaccionBean;
import soporte.bean.ValidaCajasTransferBean;
import soporte.dao.ValidaCajasTransferDAO;

public class ValidaCajasTransferServicio {
	/*
	* Referencias necesarias
	*/
	ValidaCajasTransferDAO validaCajasTransferDAO = null;

	/*
	* Interface para el control de las transacciones disponibles
	*/
	public static interface Enum_Transaccion {
		int alta = 1;
		int destinatarios = 2;
	}

	/*
	* Interface para el control de las consultas disponibles
	*/
	public static interface Enum_Consulta {
		int principal = 1;
	}

	/*
	* Interface para el control de las listas disponibles
	*/
	public static interface Enum_Lista {
		int listaDestinatarios = 1;
		int listaConCopia 	   = 2;
	}

	/*
	* Contructor de la clase
	*/
	public ValidaCajasTransferServicio() {
		super();
		// TODO Auto-generated constructor stub
	}

	/**
	 * Metodo principal para las transacciones Alta,Modificacion,Actualizacio y Baja
	 * @param instance Modelo requerido
	 * @param tipoTransaccion Tipo de Transaccion
	 * @param tipoActualizacion Tipo de Actualizacion
	 * @return MensajeTransaccionBean Modelo que retorna una vez realizada la operacion
	 */
	public MensajeTransaccionBean grabaTransaccion(ValidaCajasTransferBean instance, int tipoTransaccion, int tipoActualizacion, String detalles){
		MensajeTransaccionBean mensaje = null;
		ArrayList listaDetalle = null;
		switch (tipoTransaccion) {
			case Enum_Transaccion.alta:
				mensaje = validaCajasTransferDAO.guardar(instance, tipoActualizacion);
				break;
			case Enum_Transaccion.destinatarios:
				listaDetalle = (ArrayList) creaDetalle(detalles);
				mensaje = validaCajasTransferDAO.grabaDetalle(instance, tipoActualizacion, listaDetalle);
				break;
		}
		return mensaje;
	}

	/**
	 * Metodo para realizar las diferentes consultas
	 * @param instance Modelo requerido
	 * @param tipoConsulta Tipo de Transaccion
	 * @return ValidaCajasTransferBean Modelo que retorna una vez realizada la operacion
	 */
	public ValidaCajasTransferBean consulta(ValidaCajasTransferBean instance, int tipoConsulta){
		ValidaCajasTransferBean validaCajasTransferBean = null;
		switch (tipoConsulta) {
			case Enum_Consulta.principal:
				validaCajasTransferBean = validaCajasTransferDAO.consultaPrincipal(instance, tipoConsulta);
				break;
		}
		return validaCajasTransferBean;
	}

	/**
	 * Metodo para consultar las diferentes listas
	 * @param instance Modelo requerido
	 * @param tipoLista Tipo de Transaccion
	 * @return List Retorna una lista de resultado
	 */
	public List lista(ValidaCajasTransferBean instance, int tipoLista){
		List lista = null;
		switch (tipoLista) {
			case Enum_Lista.listaDestinatarios:
			case Enum_Lista.listaConCopia:
				lista = validaCajasTransferDAO.listaPrincipal(instance, tipoLista);
				break;
		}
		return lista;
	}
	
	public List<ValidaCajasTransferBean> creaDetalle(String detalles) {
		StringTokenizer tokensBean = new StringTokenizer(detalles, "[");
		String stringCampos;
		String tokensCampos[];
		ValidaCajasTransferBean detalle;
		List<ValidaCajasTransferBean> listaDetalle = new ArrayList<ValidaCajasTransferBean>();
		
		try {
			while(tokensBean.hasMoreTokens()) {
				detalle = new ValidaCajasTransferBean();
				stringCampos = tokensBean.nextToken();
				tokensCampos = herramientas.Utileria.divideString(stringCampos, "]");
				detalle.setDestinatarioID(tokensCampos[0]);
				detalle.setTipo(tokensCampos[1]);
				
				listaDetalle.add(detalle);
			}
		} catch (Exception e){
			e.printStackTrace();
		}
		return listaDetalle;
	}

	/*
	* Setters y Getters
	*/
	public ValidaCajasTransferDAO getValidaCajasTransferDAO() {
		return validaCajasTransferDAO;
	}

	public void setValidaCajasTransferDAO(ValidaCajasTransferDAO validaCajasTransferDAO) {
		this.validaCajasTransferDAO = validaCajasTransferDAO;
	}
}
