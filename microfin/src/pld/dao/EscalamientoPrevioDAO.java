package pld.dao;
import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.CallableStatementCallback;
import org.springframework.jdbc.core.CallableStatementCreator;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;
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

import org.springframework.jdbc.core.RowMapper;

import cliente.bean.ClienteBean;
import pld.bean.EscalamientoPrevioBean;

public class EscalamientoPrevioDAO extends BaseDAO{

	public EscalamientoPrevioDAO() {
		super();
	}


	private final static String salidaPantalla = "S";
	/* Modificación de Parámetros de Alertas Automáticas */


	public MensajeTransaccionBean grabarEscalPrev(final EscalamientoPrevioBean escalamientoPrevioBean) {
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
					String query = "call PLDESCOPEPREALT(?,?,?,?,?,"
													  + "?,?,?,?,?,"
													  + "?,?,?,?,?,"
													  + "?);";

					CallableStatement sentenciaStore = arg0.prepareCall(query);
					sentenciaStore.setInt("Par_FolioID",Utileria.convierteEntero(escalamientoPrevioBean.getFolioID()));
					sentenciaStore.setInt("Par_NivelRiesgoID",Utileria.convierteEntero(escalamientoPrevioBean.getNivelRiesgoID()));
					sentenciaStore.setInt("Par_RolTitular",Utileria.convierteEntero(escalamientoPrevioBean.getRolTitular()));
					sentenciaStore.setInt("Par_RolSuplente",Utileria.convierteEntero(escalamientoPrevioBean.getRolSuplente()));
					sentenciaStore.setString("Par_FechaVigencia",Utileria.convierteFecha(escalamientoPrevioBean.getFechaVigencia()));
					sentenciaStore.setString("Par_Estatus",escalamientoPrevioBean.getEstatus());

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
						mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .EscalamientoPrevioDAO.grabarEscalPrev");
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
			throw new Exception(Constantes.MSG_ERROR + " .EscalamientoPrevioDAO.grabarEscalPrev");
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

		loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en modificacion de parametros escalamiento previo", e);
	}
	return mensajeBean;
}
});
return mensaje;
}

	public MensajeTransaccionBean bajaEscalPrev(final EscalamientoPrevioBean escalamientoPrevioBean, final int tipoTransaccion) {
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
					String query = "call PLDESCOPEPREACT(?,?,?,?,?,"
													  + "?,?,?,?,?,"
													  + "?,?);";

					CallableStatement sentenciaStore = arg0.prepareCall(query);
					sentenciaStore.setInt("Par_FolioID",Utileria.convierteEntero(escalamientoPrevioBean.getFolioID()));
					sentenciaStore.setInt("Par_NumAct",tipoTransaccion);

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
						mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .EscalamientoPrevioDAO.bajaEscalPrev");
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
			throw new Exception(Constantes.MSG_ERROR + " .EscalamientoPrevioDAO.bajaEscalPrev");
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

		loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en baja de escalamiento previo", e);
	}
	return mensajeBean;
}
});
return mensaje;
}

	public MensajeTransaccionBean modificaEscalPrev(final EscalamientoPrevioBean escalamientoPrevioBean) {
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
					String query = "call PLDESCOPEPREMOD(?,?,?,?,?,"
													  + "?,?,?,?,?,"
													  + "?,?,?,?,?,"
													  + "?);";

					CallableStatement sentenciaStore = arg0.prepareCall(query);
					sentenciaStore.setInt("Par_FolioID",Utileria.convierteEntero(escalamientoPrevioBean.getFolioID()));
					sentenciaStore.setInt("Par_NivelRiesgoID",Utileria.convierteEntero(escalamientoPrevioBean.getNivelRiesgoID()));
					sentenciaStore.setInt("Par_RolTitular",Utileria.convierteEntero(escalamientoPrevioBean.getRolTitular()));
					sentenciaStore.setInt("Par_RolSuplente",Utileria.convierteEntero(escalamientoPrevioBean.getRolSuplente()));
					sentenciaStore.setString("Par_FechaVigencia",Utileria.convierteFecha(escalamientoPrevioBean.getFechaVigencia()));
					sentenciaStore.setString("Par_Estatus",escalamientoPrevioBean.getEstatus());

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
						mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .EscalamientoPrevioDAO.modificaParametrosEscala");
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
			throw new Exception(Constantes.MSG_ERROR + " .EscalamientoPrevioDAO.modificaParametrosEscala");
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

		loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en modificacion de parametros escalamiento previo", e);
	}
	return mensajeBean;
}
});
return mensaje;
}

	/*---------consultas--------*/

	public EscalamientoPrevioBean consultaPrincipal(EscalamientoPrevioBean escalamientoPrevio, int tipoConsulta) {
		// TODO Auto-generated method stub
		String query = "call PLDESCOPEPRECON(?,?,?,?,?,?,?,?,?);";

					Object[] parametros = {
							Constantes.ENTERO_CERO,
							tipoConsulta,
							Constantes.ENTERO_CERO,
							Constantes.ENTERO_CERO,
							Constantes.FECHA_VACIA,
							Constantes.STRING_VACIO,
							"EscalamientoPrevioDAO.consultaPrincipal",
							Constantes.ENTERO_CERO,
							Constantes.ENTERO_CERO};

	loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PLDESCOPEPRECON(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
		public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				EscalamientoPrevioBean escalamientoPrevio = new EscalamientoPrevioBean();
				escalamientoPrevio.setFolioID(String.valueOf(resultSet.getInt(1)));
				escalamientoPrevio.setNivelRiesgoID(String.valueOf(resultSet.getInt(2)));
				escalamientoPrevio.setRolTitular(String.valueOf(resultSet.getInt(3)));
				escalamientoPrevio.setRolSuplente(String.valueOf(resultSet.getInt(4)));
				escalamientoPrevio.setFechaVigencia(resultSet.getString(5));
				escalamientoPrevio.setEstatus(resultSet.getString(6));

				return escalamientoPrevio;

		}
	});

	return matches.size() > 0 ? (EscalamientoPrevioBean) matches.get(0) : null;
}


	public EscalamientoPrevioBean consultaFolioVigente(EscalamientoPrevioBean escalamientoPrevio, int tipoConsulta) {
		// TODO Auto-generated method stub
		String query = "call PLDESCOPEPRECON(?,?,?,?,?,?,?,?,?);";

					Object[] parametros = {
							escalamientoPrevio.getFolioID(),
							tipoConsulta,
							Constantes.ENTERO_CERO,
							Constantes.ENTERO_CERO,
							Constantes.FECHA_VACIA,
							Constantes.STRING_VACIO,
							"EscalamientoPrevioDAO.consultaPrincipal",
							Constantes.ENTERO_CERO,
							Constantes.ENTERO_CERO};

	loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PLDESCOPEPRECON(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
		public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				EscalamientoPrevioBean escalamientoPrevio = new EscalamientoPrevioBean();
				escalamientoPrevio.setFolioID(String.valueOf(resultSet.getInt(1)));
				escalamientoPrevio.setNivelRiesgoID(String.valueOf(resultSet.getInt(2)));
				escalamientoPrevio.setRolTitular(String.valueOf(resultSet.getInt(3)));
				escalamientoPrevio.setRolSuplente(String.valueOf(resultSet.getInt(4)));
				escalamientoPrevio.setFechaVigencia(resultSet.getString(5));
				escalamientoPrevio.setEstatus(resultSet.getString(6));

				return escalamientoPrevio;

		}
	});

	return matches.size() > 0 ? (EscalamientoPrevioBean) matches.get(0) : null;
}

	public EscalamientoPrevioBean consultaRol(EscalamientoPrevioBean escalamientoPrevio, int tipoConsulta) {
		String query = "call ROLESCON(?,?,?,?,?,?,?,?,?);";

		Object[] parametros = { escalamientoPrevio.getRolTitular(),

				tipoConsulta,
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"EscalamientoSolDAO.consultaPrincipal",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO};

		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call ROLESCON(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
	EscalamientoPrevioBean escalamientoPrevio = new EscalamientoPrevioBean();
	escalamientoPrevio.setRolTitularDescripcion(resultSet.getString("Descripcion"));

	return escalamientoPrevio;

}
});

return matches.size() > 0 ? (EscalamientoPrevioBean) matches.get(0) : null;
}


}
