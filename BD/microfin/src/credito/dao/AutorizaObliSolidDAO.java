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

import credito.bean.AutorizaObliSolidBean;
import credito.bean.AutorizaObliSolidDetalleBean;
import credito.bean.ObliSolidariosPorSoliciDetalleBean;
import credito.bean.ProductosCreditoBean;


public class AutorizaObliSolidDAO extends BaseDAO{

	java.sql.Date fecha = null;

	public AutorizaObliSolidDAO() {
		super();
	}
	private final static String salidaPantalla = "S";

	public MensajeTransaccionBean altaObligados(final AutorizaObliSolidBean autorizaObliSolidBean) {
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
					String query = "call OBLSOLIDARIOSPORSOLIALT(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?);";

					CallableStatement sentenciaStore = arg0.prepareCall(query);

					sentenciaStore.setInt("Par_SolCreditoID",Utileria.convierteEntero(autorizaObliSolidBean.getSolicitudCreditoID()));
					sentenciaStore.setInt("Par_OblSolidID",Utileria.convierteEntero(autorizaObliSolidBean.getObligadoID()));
					sentenciaStore.setInt("Par_ClienteID",Utileria.convierteEntero(autorizaObliSolidBean.getClienteID()));
					sentenciaStore.setInt("Par_ProspectoID",Utileria.convierteEntero(autorizaObliSolidBean.getProspectoID()));
					sentenciaStore.setString("Par_Estatus",autorizaObliSolidBean.ESTATUS_ALTA);

					sentenciaStore.setInt("Par_TipoRelacionID", Utileria.convierteEntero(autorizaObliSolidBean.getParentescoID()));
					sentenciaStore.setDouble("Par_TiempoDeConocido", Utileria.convierteDoble(autorizaObliSolidBean.getTiempoConocido()));
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
						mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .AutorizaObliSolidDAO.alta");
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
			throw new Exception(Constantes.MSG_ERROR + " .AutorizaObliSolidDAO.alta");
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
		loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta de Obligados Solidarios por solicitud", e);
	}
	return mensajeBean;
}
});
return mensaje;
}

	// Actualizacion de Obligados Solidarios: Autorizacion

	public MensajeTransaccionBean actualizaObligados(final AutorizaObliSolidBean autorizaObliSolidBean) {
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
					String query = "call OBLSOLIDARIOSPORSOLIALT(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?);";

					CallableStatement sentenciaStore = arg0.prepareCall(query);

					sentenciaStore.setInt("Par_SolCreditoID",Utileria.convierteEntero(autorizaObliSolidBean.getSolicitudCreditoID()));
					sentenciaStore.setInt("Par_OblSolidID",Utileria.convierteEntero(autorizaObliSolidBean.getObligadoID()));
					sentenciaStore.setInt("Par_ClienteID",Utileria.convierteEntero(autorizaObliSolidBean.getClienteID()));
					sentenciaStore.setInt("Par_ProspectoID",Utileria.convierteEntero(autorizaObliSolidBean.getProspectoID()));
					sentenciaStore.setString("Par_Estatus",autorizaObliSolidBean.ESTATUS_AUTORIZADO);

					sentenciaStore.setInt("Par_TipoRelacionID", Utileria.convierteEntero(autorizaObliSolidBean.getParentescoID()));
					sentenciaStore.setDouble("Par_TiempoDeConocido", Utileria.convierteDoble(autorizaObliSolidBean.getTiempoConocido()));
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
						mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .AutorizaObliSolidDAO.actualiza");
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
			throw new Exception(Constantes.MSG_ERROR + " .AutorizaObliSolidDAO.alta");
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
		loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en actualizacion de Obligados Solidarios|", e);
	}
	return mensajeBean;
}
});
return mensaje;
}



/*------------Baja de Avales-------------*/

	public MensajeTransaccionBean baja(final AutorizaObliSolidBean autorizaObliSolidBean, final int tipoBaja) {

		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
		public Object doInTransaction(TransactionStatus transaction) {
			MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
			try {

/*---------------Query con el SP-------------*/
				String query = "call OBLSOLIDARIOSPORSOLIBAJ(?,?,?,?,?,?,?,?,?,?,?,?);";
				Object[] parametros = {

						Utileria.convierteEntero(autorizaObliSolidBean.getSolicitudCreditoID()),
						Utileria.convierteEntero(autorizaObliSolidBean.getObligadoID()),
						Utileria.convierteEntero(autorizaObliSolidBean.getClienteID()),
						Utileria.convierteEntero(autorizaObliSolidBean.getProspectoID()),
						tipoBaja,

						parametrosAuditoriaBean.getEmpresaID(),
						parametrosAuditoriaBean.getUsuario(),
						parametrosAuditoriaBean.getFecha(),
						parametrosAuditoriaBean.getDireccionIP(),
						parametrosAuditoriaBean.getNombrePrograma(),
						parametrosAuditoriaBean.getSucursal(),
						parametrosAuditoriaBean.getNumeroTransaccion()
						};
				loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call OBLSOLIDARIOSPORSOLIBAJ(  " + Arrays.toString(parametros) + ")");


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
				loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en baja de Obligados Solidarios", e);
			}
			return mensajeBean;
		}
	});
	return mensaje;
}


	public MensajeTransaccionBean grabaListaObligados(final AutorizaObliSolidBean autorizaObliSolidBean, final List listaObligados, final int tipoBaja ) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {

					AutorizaObliSolidBean obligadosBean;
					mensajeBean = baja(autorizaObliSolidBean, tipoBaja);

					if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}

					for(int i=0; i<listaObligados.size(); i++){
						obligadosBean = (AutorizaObliSolidBean)listaObligados.get(i);
						mensajeBean = altaObligados(obligadosBean);

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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en lista de actualizacion de Obligados Solidarios", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}



	public MensajeTransaccionBean actualizaListaObligados(final AutorizaObliSolidBean autorizaObliSolidBean, final List listaObligados, final int tipoBaja ) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {

					AutorizaObliSolidBean obligadosBean;
					mensajeBean = baja(autorizaObliSolidBean, tipoBaja);

					if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}

					for(int i=0; i<listaObligados.size(); i++){
						obligadosBean = (AutorizaObliSolidBean)listaObligados.get(i);
						mensajeBean = actualizaObligados(obligadosBean);

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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en autorizacion de Obligados Solidarios", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	//Listado Alfanumerico de los obligados solidarios
	public List listaAlfanumerica(AutorizaObliSolidBean autorizaObliSolidBean, int tipoLista){
		String query = "call OBLSOLIDARIOSPORSOLILIS(?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {
					autorizaObliSolidBean.getSolicitudCreditoID(),
					tipoLista,
					parametrosAuditoriaBean.getEmpresaID(),
					parametrosAuditoriaBean.getUsuario(),
					parametrosAuditoriaBean.getFecha(),
					parametrosAuditoriaBean.getDireccionIP(),
					"AutorizaObliSolidDAO.listaAlfanumerica",
					parametrosAuditoriaBean.getSucursal(),
					parametrosAuditoriaBean.getNumeroTransaccion()};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call OBLSOLIDARIOSPORSOLILIS(  "  + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				AutorizaObliSolidDetalleBean autorizaObliSolidDetalleBean = new AutorizaObliSolidDetalleBean();
				autorizaObliSolidDetalleBean.setObligadoID(resultSet.getString(1));
				autorizaObliSolidDetalleBean.setClienteID(resultSet.getString(2));
				autorizaObliSolidDetalleBean.setProspectoID(resultSet.getString(3));
				autorizaObliSolidDetalleBean.setNombre(resultSet.getString(4));
				autorizaObliSolidDetalleBean.setParentescoID(resultSet.getString("ParentescoID"));
				autorizaObliSolidDetalleBean.setNombreParentesco(resultSet.getString("NombreParentesco"));
				autorizaObliSolidDetalleBean.setTiempoConocido(resultSet.getString("TiempoDeConocido"));
				return autorizaObliSolidDetalleBean;
			}
		});
		return matches;
		}

	//Listado de Obligados Reestructura
	public List listaObligadosReest(AutorizaObliSolidBean autorizaObliSolidBean, int tipoLista){
		String query = "call OBLSOLIDARIOSPORSOLILIS(?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {

					autorizaObliSolidBean.getSolicitudCreditoID(),
					tipoLista,

					parametrosAuditoriaBean.getEmpresaID(),
					parametrosAuditoriaBean.getUsuario(),
					parametrosAuditoriaBean.getFecha(),
					parametrosAuditoriaBean.getDireccionIP(),
					"AutorizaObliSolidDAO.listaObligadosReest",
					parametrosAuditoriaBean.getSucursal(),
					parametrosAuditoriaBean.getNumeroTransaccion()};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call OBLSOLIDARIOSPORSOLILIS(  "  + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				AutorizaObliSolidDetalleBean autorizaObliSolidDetalleBean = new AutorizaObliSolidDetalleBean();
				autorizaObliSolidDetalleBean.setObligadoID(resultSet.getString("OblSolidID"));
				autorizaObliSolidDetalleBean.setClienteID(resultSet.getString("ClienteID"));
				autorizaObliSolidDetalleBean.setProspectoID(resultSet.getString("ProspectoID"));
				autorizaObliSolidDetalleBean.setNombre(resultSet.getString("Nombre"));
				autorizaObliSolidDetalleBean.setParentescoID(resultSet.getString("ParentescoID"));
				autorizaObliSolidDetalleBean.setNombreParentesco(resultSet.getString("NombreParentesco"));
				autorizaObliSolidDetalleBean.setTiempoConocido(resultSet.getString("TiempoDeConocido"));
				return autorizaObliSolidDetalleBean;

			}
		});
		return matches;
	}

	/* Consulta de el numero Obligados Solidarios por Solicitud de Credito y el estatus de estos*/
	public AutorizaObliSolidDetalleBean consultaOblAsignPorSoli(AutorizaObliSolidDetalleBean autorizaObliSolidDetalleBean, int tipoConsulta) {
		AutorizaObliSolidDetalleBean autorizaObliSolidConsulta = new AutorizaObliSolidDetalleBean();
		try{
			//Query con el Store Procedure
			String query = "call OBLSOLIDARIOSPORSOLICON(?,? ,?,?,?,?,?,?,?);";
			Object[] parametros = { Utileria.convierteEntero(autorizaObliSolidDetalleBean.getSolicitudCreditoID()),
									tipoConsulta,
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.FECHA_VACIA,
									Constantes.STRING_VACIO,
									Constantes.STRING_VACIO,
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call OBLSOLIDARIOSPORSOLICON(  " + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

					AutorizaObliSolidDetalleBean autorizaObliSolidDetalleBean = new AutorizaObliSolidDetalleBean();
					autorizaObliSolidDetalleBean.setSolicitudCreditoID(resultSet.getString("SolicitudCreditoID"));
					autorizaObliSolidDetalleBean.setNumOblAsign(resultSet.getString("NumOblAsig"));
					autorizaObliSolidDetalleBean.setEstatus(resultSet.getString("Estatus"));

					return autorizaObliSolidDetalleBean;
				}
			});
		autorizaObliSolidConsulta= matches.size() > 0 ? (AutorizaObliSolidDetalleBean) matches.get(0) : null;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en consulta de consultaOblAsignPorSoli ", e);
		}
		return autorizaObliSolidConsulta;
	}

}
