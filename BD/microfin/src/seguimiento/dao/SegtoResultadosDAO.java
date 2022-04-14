package seguimiento.dao;

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

import seguimiento.bean.SegtoResultadosBean;

public class SegtoResultadosDAO extends BaseDAO{
	public SegtoResultadosDAO(){
		super();
	}

	public MensajeTransaccionBean altaSegtoResultados(final SegtoResultadosBean segtoResultadosBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "call SEGTORESULTADOSALT(?,?,?,?,  ?,?,?,  ?,?,?,?,?,?,?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);
								sentenciaStore.setString("Par_Descripcion",segtoResultadosBean.getDescripcion());
								sentenciaStore.setString("Par_Alcance",segtoResultadosBean.getAlcance());
								sentenciaStore.setString("Par_ReqSupervisor",segtoResultadosBean.getReqSupervisor());
								sentenciaStore.setString("Par_Estatus",segtoResultadosBean.getEstatus());

								sentenciaStore.setString("Par_Salida",	Constantes.salidaSI);
								sentenciaStore.registerOutParameter("Par_NumErr",Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen",Types.VARCHAR);

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
							public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,DataAccessException {
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
									mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.");
								}
								return mensajeTransaccion;
							}
						});
					if(mensajeBean ==  null){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {

					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta de Resultados", e);
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	public MensajeTransaccionBean modificaSegtoResultados(final SegtoResultadosBean segtoResultadosBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {

								String query = "call SEGTORESULTADOSMOD(?,?,?,?,?, ?,?,?, ?,?,?,?,?,?,?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);

								sentenciaStore.setInt("Par_ResultadoSegtoID",Utileria.convierteEntero(segtoResultadosBean.getResultadoSegtoID()));
								sentenciaStore.setString("Par_Descripcion",segtoResultadosBean.getDescripcion());
								sentenciaStore.setString("Par_Alcance",segtoResultadosBean.getAlcance());
								sentenciaStore.setString("Par_ReqSupervisor",segtoResultadosBean.getReqSupervisor());
								sentenciaStore.setString("Par_Estatus",segtoResultadosBean.getEstatus());

								sentenciaStore.setString("Par_Salida",	Constantes.salidaSI);
								sentenciaStore.registerOutParameter("Par_NumErr",Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen",Types.VARCHAR);

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
							public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,DataAccessException {
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
									mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.");
								}
								return mensajeTransaccion;
							}
						});
					if(mensajeBean ==  null){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {

					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en la modificacion de Resultados", e);
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}


	public SegtoResultadosBean consulta(final int
			tipoConsulta, SegtoResultadosBean segtoResultadosBean) {
		//Query con el Store Procedure
		String query = "call SEGTORESULTADOSCON(?,?,  ?,?,?,?,?,?,?);";
		Object[] parametros = {	segtoResultadosBean.getResultadoSegtoID(),
								tipoConsulta,

								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"SegtoRecomendasDAO.consulta",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO
						};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call SEGTORESULTADOSCON(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				SegtoResultadosBean seguimientosResultados = new SegtoResultadosBean();

				seguimientosResultados.setResultadoSegtoID(resultSet.getString(1));
				seguimientosResultados.setDescripcion(resultSet.getString(2));
				seguimientosResultados.setAlcance(resultSet.getString(3));
				seguimientosResultados.setReqSupervisor(resultSet.getString(4));
				seguimientosResultados.setEstatus(resultSet.getString(5));

				return seguimientosResultados;
			}
		});
		return matches.size() > 0 ? (SegtoResultadosBean) matches.get(0) : null;
	}

	public SegtoResultadosBean consultaAlcance(SegtoResultadosBean segtoRes, int tipoConsulta){
		SegtoResultadosBean segto = new SegtoResultadosBean();
		try{
			// Query con el Store Procedure
			String query = "call SEGTORESULTADOSCON(?,?, ?,?,?,?,?,?,?);";

			Object[] parametros = {
									segtoRes.getResultadoSegtoID(),
									tipoConsulta,

									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.FECHA_VACIA,
									Constantes.STRING_VACIO,
									"SegtoManualDAO.consultaPrincipal",
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO
								};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call SEGTORESULTADOSCON(  " + Arrays.toString(parametros) + ")");

		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum)
						throws SQLException {
					SegtoResultadosBean segtoRes = new SegtoResultadosBean();
					segtoRes.setResultadoSegtoID(resultSet.getString(1));
					segtoRes.setAlcance(resultSet.getString(2));
					segtoRes.setReqSupervisor(resultSet.getString(3));
					return segtoRes;

				}
			});

			segto =  matches.size() > 0 ? (SegtoResultadosBean) matches.get(0) : null;
		}catch(Exception e){
			e.printStackTrace();
		}
		return segto;
	}

	public List listaPrincipal(SegtoResultadosBean segtoResultadosBean, int tipoLista) {
		List listaResultado = null;
		try{
			//Query con el Store Procedure
			String query = "call SEGTORESULTADOSLIS(?,?,?,?, ?,?,?,?,?,?,?);";
			Object[] parametros = {	segtoResultadosBean.getDescripcion(),
									segtoResultadosBean.getAlcance(),
									segtoResultadosBean.getEstatus(),
									tipoLista,

									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.FECHA_VACIA,
									Constantes.STRING_VACIO,
									"SegtoResultadosDAO.listaPrincipal",
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO
									};

			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call SEGTORESULTADOSLIS(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					SegtoResultadosBean segtoResultadosBean = new SegtoResultadosBean();
					segtoResultadosBean.setResultadoSegtoID(resultSet.getString("ResultadoSegtoID"));
					segtoResultadosBean.setDescripcion(resultSet.getString("Descripcion"));
					segtoResultadosBean.setAlcance(resultSet.getString("Alcance"));
					return segtoResultadosBean;
				}
			});
			listaResultado =  matches;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en lista SEGTORESULTADOSLIS: " +e);
		}
		return listaResultado;
	}

	public List listaResultados(SegtoResultadosBean segtoResultadosBean, int tipoLista) {
		List listaResultado = null;
		try{
			//Query con el Store Procedure
			String query = "call SEGTORESULTADOSLIS(?,?,?,?, ?,?,?,?,?,?,?);";
			Object[] parametros = {	segtoResultadosBean.getDescripcion(),
									Constantes.STRING_VACIO,
									Constantes.STRING_VACIO,
									tipoLista,

									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.FECHA_VACIA,
									Constantes.STRING_VACIO,
									"SegtoResultadosDAO.listaPrincipal",
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO
									};

			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call SEGTORESULTADOSLIS(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					SegtoResultadosBean segtoResultadosBean = new SegtoResultadosBean();
					segtoResultadosBean.setResultadoSegtoID(resultSet.getString("ResultadoSegtoID"));
					segtoResultadosBean.setDescripcion(resultSet.getString("Descripcion"));
					return segtoResultadosBean;
				}
			});
			listaResultado =  matches;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en lista SEGTORESULTADOSLIS: " +e);
		}
		return listaResultado;
	}
}
