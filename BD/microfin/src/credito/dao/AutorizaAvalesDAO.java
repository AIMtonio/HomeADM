package credito.dao;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;

import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.Arrays;
import java.util.List;

import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.CallableStatementCallback;
import org.springframework.jdbc.core.CallableStatementCreator;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;

import credito.bean.AutorizaAvalesBean;
import credito.bean.AutorizaAvalesDetalleBean;


public class AutorizaAvalesDAO extends BaseDAO{

	java.sql.Date fecha = null;

	public AutorizaAvalesDAO() {
		super();
	}
	private final static String salidaPantalla = "S";

	public MensajeTransaccionBean altaAvales(final AutorizaAvalesBean autorizaAvalesBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					//Query con el Store Procedure
			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
					String query = "call AVALESPORSOLIALT(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?);";

					CallableStatement sentenciaStore = arg0.prepareCall(query);

					sentenciaStore.setInt("Par_SolCreditoID",Utileria.convierteEntero(autorizaAvalesBean.getSolicitudCreditoID()));
					sentenciaStore.setInt("Par_AvalID",Utileria.convierteEntero(autorizaAvalesBean.getAvalID()));
					sentenciaStore.setInt("Par_ClienteID",Utileria.convierteEntero(autorizaAvalesBean.getClienteID()));
					sentenciaStore.setInt("Par_ProspectoID",Utileria.convierteEntero(autorizaAvalesBean.getProspectoID()));
					sentenciaStore.setString("Par_Estatus",AutorizaAvalesBean.ESTATUS_ALTA);

					sentenciaStore.setInt("Par_TipoRelacionID", Utileria.convierteEntero(autorizaAvalesBean.getParentescoID()));
					sentenciaStore.setDouble("Par_TiempoDeConocido", Utileria.convierteDoble(autorizaAvalesBean.getTiempoConocido()));
					sentenciaStore.setString("Par_Salida",salidaPantalla);
					//Parametros de OutPut
					sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
					sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

					//Parametros de Auditoria
					sentenciaStore.setInt("Aud_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
					sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
					sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
					sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
					sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
					sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
					sentenciaStore.setLong("Aud_NumTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());
					loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());
					return sentenciaStore;
				}
			},new CallableStatementCallback() {
				public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,
																								DataAccessException {
					MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
					if(callableStatement.execute()){
						ResultSet resultadosStore = callableStatement.getResultSet();

						resultadosStore.next();
						mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
						mensajeTransaccion.setDescripcion(resultadosStore.getString(2));
						mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
						mensajeTransaccion.setConsecutivoString(resultadosStore.getString(4));

					}else{
						mensajeTransaccion.setNumero(999);
						mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .AutorizaAvalesDAO.alta");
						mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
						mensajeTransaccion.setConsecutivoString(Constantes.STRING_VACIO);
					}

					return mensajeTransaccion;
				}
			}
			);

		if(mensajeBean ==  null){
			mensajeBean = new MensajeTransaccionBean();
			mensajeBean.setNumero(999);
			throw new Exception(Constantes.MSG_ERROR + " .AutorizaAvalesDAO.alta");
		}else if(mensajeBean.getNumero()!=0){
			throw new Exception(mensajeBean.getDescripcion());
		}
	} catch (Exception e) {

		if (mensajeBean.getNumero() == 0) {
			mensajeBean.setNumero(999);
		}
		mensajeBean.setDescripcion(e.getMessage());
		transaction.setRollbackOnly();
		e.printStackTrace();
		loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta de avales por solicitud", e);
	}
	return mensajeBean;
}
});
return mensaje;
}

	// Actualizacion de avales: Autorizacion

	public MensajeTransaccionBean actualizaAvales(final AutorizaAvalesBean autorizaAvalesBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					//Query con el Store Procedure
			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
					String query = "call AVALESPORSOLIALT(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?);";

					CallableStatement sentenciaStore = arg0.prepareCall(query);

					sentenciaStore.setInt("Par_SolCreditoID",Utileria.convierteEntero(autorizaAvalesBean.getSolicitudCreditoID()));
					sentenciaStore.setInt("Par_AvalID",Utileria.convierteEntero(autorizaAvalesBean.getAvalID()));
					sentenciaStore.setInt("Par_ClienteID",Utileria.convierteEntero(autorizaAvalesBean.getClienteID()));
					sentenciaStore.setInt("Par_ProspectoID",Utileria.convierteEntero(autorizaAvalesBean.getProspectoID()));
					sentenciaStore.setString("Par_Estatus",AutorizaAvalesBean.ESTATUS_AUTORIZADO);

					sentenciaStore.setInt("Par_TipoRelacionID", Utileria.convierteEntero(autorizaAvalesBean.getParentescoID()));
					sentenciaStore.setDouble("Par_TiempoDeConocido", Utileria.convierteDoble(autorizaAvalesBean.getTiempoConocido()));
					sentenciaStore.setString("Par_Salida",salidaPantalla);
					//Parametros de OutPut
					sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
					sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

					//Parametros de Auditoria
					sentenciaStore.setInt("Aud_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
					sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
					sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
					sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
					sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
					sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
					sentenciaStore.setLong("Aud_NumTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());
					loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());
					return sentenciaStore;
				}
			},new CallableStatementCallback() {
				public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,
																								DataAccessException {
					MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
					if(callableStatement.execute()){
						ResultSet resultadosStore = callableStatement.getResultSet();

						resultadosStore.next();
						mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
						mensajeTransaccion.setDescripcion(resultadosStore.getString(2));
						mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
						mensajeTransaccion.setConsecutivoString(resultadosStore.getString(4));

					}else{
						mensajeTransaccion.setNumero(999);
						mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .AutorizaAvalesDAO.actualiza");
						mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
						mensajeTransaccion.setConsecutivoString(Constantes.STRING_VACIO);
					}

					return mensajeTransaccion;
				}
			}
			);

		if(mensajeBean ==  null){
			mensajeBean = new MensajeTransaccionBean();
			mensajeBean.setNumero(999);
			throw new Exception(Constantes.MSG_ERROR + " .AutorizaAvalesDAO.alta");
		}else if(mensajeBean.getNumero()!=0){
			throw new Exception(mensajeBean.getDescripcion());
		}
	} catch (Exception e) {

		if (mensajeBean.getNumero() == 0) {
			mensajeBean.setNumero(999);
		}
		mensajeBean.setDescripcion(e.getMessage());
		transaction.setRollbackOnly();
		e.printStackTrace();
		loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en actualizacion de avales", e);
	}
	return mensajeBean;
}
});
return mensaje;
}



/*------------Baja de Avales-------------*/

	public MensajeTransaccionBean baja(final AutorizaAvalesBean autorizaAvalesBean, final int tipoBaja) {

		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
		public Object doInTransaction(TransactionStatus transaction) {
			MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
			try {

/*---------------Query con el SP-------------*/
				String query = "call AVALESPORSOLIBAJ(?,?,?,?,?,?,?,?,?,?,?,?);";
				Object[] parametros = {

						Utileria.convierteEntero(autorizaAvalesBean.getSolicitudCreditoID()),
						Utileria.convierteEntero(autorizaAvalesBean.getAvalID()),
						Utileria.convierteEntero(autorizaAvalesBean.getClienteID()),
						Utileria.convierteEntero(autorizaAvalesBean.getProspectoID()),
						tipoBaja,

						parametrosAuditoriaBean.getEmpresaID(),
						parametrosAuditoriaBean.getUsuario(),
						parametrosAuditoriaBean.getFecha(),
						parametrosAuditoriaBean.getDireccionIP(),
						parametrosAuditoriaBean.getNombrePrograma(),
						parametrosAuditoriaBean.getSucursal(),
						parametrosAuditoriaBean.getNumeroTransaccion()
						};
				loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call AVALESPORSOLIBAJ(  " + Arrays.toString(parametros) + ")");


		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
					public Object mapRow(ResultSet resultSet, int rowNum)
							throws SQLException {
						MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
						mensaje.setNumero(Integer.valueOf(resultSet.getString(1)).intValue());
						mensaje.setDescripcion(resultSet.getString(2));
						mensaje.setNombreControl(resultSet.getString(3));
						return mensaje;
					}
				});
				return matches.size() > 0 ? (MensajeTransaccionBean) matches.get(0) : null;
			} catch (Exception e) {
				if(mensajeBean.getNumero()==0){
					mensajeBean.setNumero(999);
				}
				mensajeBean.setDescripcion(e.getMessage());
				transaction.setRollbackOnly();
				e.printStackTrace();
				loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en baja de avales", e);
			}
			return mensajeBean;
		}
	});
	return mensaje;
}


	public MensajeTransaccionBean grabaListaAvales(final AutorizaAvalesBean autorizaAvalesBean, final List listaAvales, final int tipoBaja ) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {

					AutorizaAvalesBean avalesBean;
					mensajeBean = baja(autorizaAvalesBean, tipoBaja);
					//mensajeBean = actualizaAvales(autorizaAvalesBean);

					if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}

					for(int i=0; i<listaAvales.size(); i++){
						avalesBean = (AutorizaAvalesBean)listaAvales.get(i);
						mensajeBean = altaAvales(avalesBean);

						if(mensajeBean.getNumero()!=0){
							throw new Exception(mensajeBean.getDescripcion());
						}
					}
					mensajeBean = new MensajeTransaccionBean();
					mensajeBean.setNumero(0);
					mensajeBean.setDescripcion("Informacion Actualizada.");
					mensajeBean.setNombreControl("solicitudCreditoID");
				} catch (Exception e) {
					if(mensajeBean.getNumero()==0){
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en lista de actualizacion de avales", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}



	public MensajeTransaccionBean actualizaListaAvales(final AutorizaAvalesBean autorizaAvalesBean, final List listaAvales, final int tipoBaja ) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {

					AutorizaAvalesBean avalesBean;
					mensajeBean = baja(autorizaAvalesBean, tipoBaja);

					if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}

					for(int i=0; i<listaAvales.size(); i++){
						avalesBean = (AutorizaAvalesBean)listaAvales.get(i);
						mensajeBean = actualizaAvales(avalesBean);

						if(mensajeBean.getNumero()!=0){
							throw new Exception(mensajeBean.getDescripcion());
						}
					}
					mensajeBean = new MensajeTransaccionBean();
					mensajeBean.setNumero(0);
					mensajeBean.setDescripcion("Informacion Actualizada.");
					mensajeBean.setNombreControl("solicitudCreditoID");
				} catch (Exception e) {
					if(mensajeBean.getNumero()==0){
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en autorizacion de avales", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}



	public List listaAlfanumerica(AutorizaAvalesBean autorizaAvalesBean, int tipoLista){
		String query = "call AVALESPORSOLILIS(?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {

					autorizaAvalesBean.getSolicitudCreditoID(),
					tipoLista,

					parametrosAuditoriaBean.getEmpresaID(),
					parametrosAuditoriaBean.getUsuario(),
					parametrosAuditoriaBean.getFecha(),
					parametrosAuditoriaBean.getDireccionIP(),
					"AvalesPorSoliciDAO.listaAlfanumerica",
					parametrosAuditoriaBean.getSucursal(),
					parametrosAuditoriaBean.getNumeroTransaccion()};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call AVALESPORSOLILIS(  "  + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				AutorizaAvalesDetalleBean autorizaAvalesDetalleBean = new AutorizaAvalesDetalleBean();
				autorizaAvalesDetalleBean.setAvalID(resultSet.getString(1));
				autorizaAvalesDetalleBean.setClienteID(resultSet.getString(2));
				autorizaAvalesDetalleBean.setProspectoID(resultSet.getString(3));
				autorizaAvalesDetalleBean.setNombre(resultSet.getString(4));
				autorizaAvalesDetalleBean.setParentescoID(resultSet.getString("ParentescoID"));
				autorizaAvalesDetalleBean.setNombreParentesco(resultSet.getString("NombreParentesco"));
				autorizaAvalesDetalleBean.setTiempoConocido(resultSet.getString("TiempoDeConocido"));
				return autorizaAvalesDetalleBean;

			}
		});
		return matches;
		}

	public List listaAvalesReest(AutorizaAvalesBean autorizaAvalesBean, int tipoLista){
		String query = "call AVALESPORSOLILIS(?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {

					autorizaAvalesBean.getSolicitudCreditoID(),
					tipoLista,

					parametrosAuditoriaBean.getEmpresaID(),
					parametrosAuditoriaBean.getUsuario(),
					parametrosAuditoriaBean.getFecha(),
					parametrosAuditoriaBean.getDireccionIP(),
					"AvalesPorSoliciDAO.listaAlfanumerica",
					parametrosAuditoriaBean.getSucursal(),
					parametrosAuditoriaBean.getNumeroTransaccion()};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call AVALESPORSOLILIS(  "  + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				AutorizaAvalesDetalleBean autorizaAvalesDetalleBean = new AutorizaAvalesDetalleBean();
				autorizaAvalesDetalleBean.setAvalID(resultSet.getString("AvalID"));
				autorizaAvalesDetalleBean.setClienteID(resultSet.getString("ClienteID"));
				autorizaAvalesDetalleBean.setProspectoID(resultSet.getString("ProspectoID"));
				autorizaAvalesDetalleBean.setNombre(resultSet.getString("Nombre"));
				autorizaAvalesDetalleBean.setEstatusSolicitud(resultSet.getString("EstatusSolicitud"));
				autorizaAvalesDetalleBean.setParentescoID(resultSet.getString("ParentescoID"));
				autorizaAvalesDetalleBean.setNombreParentesco(resultSet.getString("NombreParentesco"));
				autorizaAvalesDetalleBean.setTiempoConocido(resultSet.getString("TiempoDeConocido"));
				return autorizaAvalesDetalleBean;

			}
		});
		return matches;
		}








}
