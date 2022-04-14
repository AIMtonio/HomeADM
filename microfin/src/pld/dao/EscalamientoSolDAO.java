package pld.dao;
import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.CallableStatementCallback;
import org.springframework.jdbc.core.CallableStatementCreator;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;
import org.springframework.transaction.support.TransactionTemplate;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.Arrays;
import java.util.List;

import org.springframework.jdbc.core.RowMapper;

import pld.bean.EscalamientoSolBean;
import pld.bean.ParametrosAlertasBean;
import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.OperacionesFechas;
import herramientas.Utileria;

public class EscalamientoSolDAO extends BaseDAO{

	public EscalamientoSolDAO() {
		super();
	}

	private final static String salidaPantalla = "S";
	/* Modificación de Parámetros de Alertas Automáticas */

	public MensajeTransaccionBean grabarParametrosEscala(final EscalamientoSolBean escalamientoSolBean) {
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
					String query = "call PLDESCALASOLALT(?,?,?,?,?,"
													  + "?,?,?,?,?,"
													  + "?,?,?,?,?,"
													  + "?,?,?,?);";


					CallableStatement sentenciaStore = arg0.prepareCall(query);
					sentenciaStore.setInt("Par_FolioID",Utileria.convierteEntero(escalamientoSolBean.getFolioID()));
					sentenciaStore.setInt("Par_NivelRiesgoID",Utileria.convierteEntero(escalamientoSolBean.getNivelRiesgoID()));
					sentenciaStore.setString("Par_Peps",escalamientoSolBean.getPeps());
					sentenciaStore.setString("Par_ActuaCuenTer",escalamientoSolBean.getActuaCuenTer());
					sentenciaStore.setString("Par_DudasAutDoc",escalamientoSolBean.getDudasAutDoc());
					sentenciaStore.setInt("Par_RolTitular",Utileria.convierteEntero(escalamientoSolBean.getRolTitular()));
					sentenciaStore.setInt("Par_RolSuplente",Utileria.convierteEntero(escalamientoSolBean.getRolSuplente()));
					sentenciaStore.setString("Par_FechaVigencia",Utileria.convierteFecha(escalamientoSolBean.getFechaVigencia()));
					sentenciaStore.setString("Par_Estatus",escalamientoSolBean.getEstatus());

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
						mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .EscalamientoSolDAO.grabarParametrosEscala");
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
			throw new Exception(Constantes.MSG_ERROR + " .EscalamientoSolDAO.grabarParametrosEscala");
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

		loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en el alta de parametros escalamiento", e);
	}
	return mensajeBean;
}
});
return mensaje;
}


	public MensajeTransaccionBean modificaParametrosEscala(final EscalamientoSolBean escalamientoSolBean) {
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
					String query = "call PLDESCALASOLMOD(?,?,?,?,?,"
													  + "?,?,?,?,?,"
													  + "?,?,?,?,?,"
													  + "?,?,?,?);";

					CallableStatement sentenciaStore = arg0.prepareCall(query);
					sentenciaStore.setInt("Par_FolioID",Utileria.convierteEntero(escalamientoSolBean.getFolioID()));
					sentenciaStore.setInt("Par_NivelRiesgoID",Utileria.convierteEntero(escalamientoSolBean.getNivelRiesgoID()));
					sentenciaStore.setString("Par_Peps",escalamientoSolBean.getPeps());
					sentenciaStore.setString("Par_ActuaCuenTer",escalamientoSolBean.getActuaCuenTer());
					sentenciaStore.setString("Par_DudasAutDoc",escalamientoSolBean.getDudasAutDoc());
					sentenciaStore.setInt("Par_RolTitular",Utileria.convierteEntero(escalamientoSolBean.getRolTitular()));
					sentenciaStore.setInt("Par_RolSuplente",Utileria.convierteEntero(escalamientoSolBean.getRolSuplente()));
					sentenciaStore.setString("Par_FechaVigencia",Utileria.convierteFecha(escalamientoSolBean.getFechaVigencia()));
					sentenciaStore.setString("Par_Estatus",escalamientoSolBean.getEstatus());

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
						mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .EscalamientoSolDAO.modificaParametrosEscala");
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
			throw new Exception(Constantes.MSG_ERROR + " .EscalamientoSolDAO.modificaParametrosEscala");
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

		loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en modificacion de parametros escalamiento", e);
	}
	return mensajeBean;
}
});
return mensaje;
}




	public MensajeTransaccionBean bajaParametrosEscala(final EscalamientoSolBean escalamientoSolBean, final int tipoTransaccion) {
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
					String query = "call PLDESCALASOLACT(?,?,?,?,?,"
													  + "?,?,?,?,?,"
													  + "?,?);";

					CallableStatement sentenciaStore = arg0.prepareCall(query);
					sentenciaStore.setInt("Par_FolioID",Utileria.convierteEntero(escalamientoSolBean.getFolioID()));
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
						mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .EscalamientoSolDAO.modificaParametrosEscala");
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
			throw new Exception(Constantes.MSG_ERROR + " .EscalamientoSolDAO.modificaParametrosEscala");
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

		loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en modificacion de parametros escalamiento", e);
	}
	return mensajeBean;
}
});
return mensaje;
}



	/*---------consultas--------*/

	public EscalamientoSolBean consultaPrincipal(EscalamientoSolBean escalamientoSol, int tipoConsulta) {
		// TODO Auto-generated method stub
		String query = "call PLDESCALASOLCON(?,?,?,?,?,?,?,?,?);";

					Object[] parametros = {
							Constantes.ENTERO_CERO,
							tipoConsulta,
							Constantes.ENTERO_CERO,
							Constantes.ENTERO_CERO,
							Constantes.FECHA_VACIA,
							Constantes.STRING_VACIO,
							"EscalamientoSolDAO.consultaPrincipal",
							Constantes.ENTERO_CERO,
							Constantes.ENTERO_CERO};

		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PLDESCALASOLCON(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
		public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				EscalamientoSolBean escalamientoSol = new EscalamientoSolBean();
				escalamientoSol.setFolioID(String.valueOf(resultSet.getInt(1)));
				escalamientoSol.setNivelRiesgoID(String.valueOf(resultSet.getInt(2)));
				escalamientoSol.setPeps(resultSet.getString(3));
				escalamientoSol.setActuaCuenTer(resultSet.getString(4));
				escalamientoSol.setDudasAutDoc(resultSet.getString(5));
				escalamientoSol.setRolTitular(String.valueOf(resultSet.getInt(6)));
				escalamientoSol.setRolSuplente(String.valueOf(resultSet.getInt(7)));
				escalamientoSol.setFechaVigencia(resultSet.getString(8));
				escalamientoSol.setEstatus(resultSet.getString(9));
				return escalamientoSol;

		}
	});

	return matches.size() > 0 ? (EscalamientoSolBean) matches.get(0) : null;
}

	public EscalamientoSolBean consultaFolioVigente(EscalamientoSolBean escalamientoSol, int tipoConsulta) {
		// TODO Auto-generated method stub
		String query = "call PLDESCALASOLCON(?,?,?,?,?,?,?,?,?);";

					Object[] parametros = {
							escalamientoSol.getFolioID(),
							tipoConsulta,
							Constantes.ENTERO_CERO,
							Constantes.ENTERO_CERO,
							Constantes.FECHA_VACIA,
							Constantes.STRING_VACIO,
							"EscalamientoSolDAO.consultaPrincipal",
							Constantes.ENTERO_CERO,
							Constantes.ENTERO_CERO};

		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PLDESCALASOLCON(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
		public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				EscalamientoSolBean escalamientoSol = new EscalamientoSolBean();
				escalamientoSol.setFolioID(String.valueOf(resultSet.getInt(1)));
				escalamientoSol.setNivelRiesgoID(String.valueOf(resultSet.getInt(2)));
				escalamientoSol.setPeps(resultSet.getString(3));
				escalamientoSol.setActuaCuenTer(resultSet.getString(4));
				escalamientoSol.setDudasAutDoc(resultSet.getString(5));
				escalamientoSol.setRolTitular(String.valueOf(resultSet.getInt(6)));
				escalamientoSol.setRolSuplente(String.valueOf(resultSet.getInt(7)));
				escalamientoSol.setFechaVigencia(resultSet.getString(8));
				escalamientoSol.setEstatus(resultSet.getString(9));
				return escalamientoSol;

		}
	});

	return matches.size() > 0 ? (EscalamientoSolBean) matches.get(0) : null;
}


	public EscalamientoSolBean consultaRol(EscalamientoSolBean escalamientoSol, int tipoConsulta) {
		String query = "call ROLESCON(?,?,?,?,?,?,?,?,?);";

		Object[] parametros = { escalamientoSol.getRolTitular(),

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
	EscalamientoSolBean escalamientoSol = new EscalamientoSolBean();
	escalamientoSol.setRolTitularDescripcion(resultSet.getString("Descripcion"));

	return escalamientoSol;

}
});

return matches.size() > 0 ? (EscalamientoSolBean) matches.get(0) : null;
}



}
