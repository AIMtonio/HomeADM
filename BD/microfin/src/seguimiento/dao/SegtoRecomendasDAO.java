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

import seguimiento.bean.SegtoRecomendasBean;

public class SegtoRecomendasDAO extends BaseDAO{
	public SegtoRecomendasDAO(){
		super();
	}

	public MensajeTransaccionBean altaSegtoRecomendas(final SegtoRecomendasBean segtoRecomendasBean) {
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
								String query = "call SEGTORECOMENDASALT(?,?,?,?,  ?,?,?,  ?,?,?,?,?,?,?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);
								sentenciaStore.setString("Par_Descripcion",segtoRecomendasBean.getDescripcion());
								sentenciaStore.setString("Par_Alcance",segtoRecomendasBean.getAlcance());
								sentenciaStore.setString("Par_ReqSupervisor",segtoRecomendasBean.getReqSupervisor());
								sentenciaStore.setString("Par_Estatus",segtoRecomendasBean.getEstatus());

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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta de cuentas de personal", e);
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	public MensajeTransaccionBean modificaSegtoRecomendas(final SegtoRecomendasBean segtoRecomendasBean) {
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
								String query = "call SEGTORECOMENDASMOD(?,?,?,?,?, ?,?,?,  ?,?,?,?,?,?,?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);
								sentenciaStore.setInt("Par_RecomendacionSegtoID",Utileria.convierteEntero(segtoRecomendasBean.getRecomendacionSegtoID()));
								sentenciaStore.setString("Par_Descripcion",segtoRecomendasBean.getDescripcion());
								sentenciaStore.setString("Par_Alcance",segtoRecomendasBean.getAlcance());
								sentenciaStore.setString("Par_ReqSupervisor",segtoRecomendasBean.getReqSupervisor());
								sentenciaStore.setString("Par_Estatus",segtoRecomendasBean.getEstatus());

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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en la modificacion de recomendaciones de seguimiento", e);
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	public SegtoRecomendasBean consulta(final int
			tipoConsulta, SegtoRecomendasBean segtoRecomendasBean) {
		//Query con el Store Procedure
		String query = "call SEGTORECOMENDASCON(?,?,  ?,?,?,?,?,?,?);";
		Object[] parametros = {	segtoRecomendasBean.getRecomendacionSegtoID(),
								tipoConsulta,

								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"SegtoRecomendasDAO.consulta",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO
						};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call SEGTORECOMENDASCON(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				SegtoRecomendasBean seguimientos = new SegtoRecomendasBean();

				seguimientos.setRecomendacionSegtoID(resultSet.getString(1));
				seguimientos.setDescripcion(resultSet.getString(2));
				seguimientos.setAlcance(resultSet.getString(3));
				seguimientos.setReqSupervisor(resultSet.getString(4));
				seguimientos.setEstatus(resultSet.getString(5));

				return seguimientos;
			}
		});
		return matches.size() > 0 ? (SegtoRecomendasBean) matches.get(0) : null;
	}

	public List listaPrincipal(SegtoRecomendasBean segtoRecomendasBean, int tipoLista) {
		List listaResultado = null;
		try{
			//Query con el Store Procedure
			String query = "call SEGTORECOMENDASLIS(?,?,?,?, ?,?,?,?,?,?,?);";
			Object[] parametros = {
									segtoRecomendasBean.getDescripcion(),
									segtoRecomendasBean.getAlcance(),
									segtoRecomendasBean.getEstatus(),
									tipoLista,

									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.FECHA_VACIA,
									Constantes.STRING_VACIO,
									"SegtoRecomendasDAO.listaPrincipal",
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO
									};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call SEGTORECOMENDASLIS(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					SegtoRecomendasBean segtoRecomendasBean = new SegtoRecomendasBean();
					segtoRecomendasBean.setRecomendacionSegtoID(resultSet.getString("RecomendacionSegtoID"));
					segtoRecomendasBean.setDescripcion(resultSet.getString("Descripcion"));
					segtoRecomendasBean.setAlcance(resultSet.getString("Alcance"));
					return segtoRecomendasBean;
				}
			});
			listaResultado =  matches;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en lista SEGTORECOMENDASLIS: " +e);
		}
		return listaResultado;
	}

	public List listaRecomendacion(SegtoRecomendasBean segtoRecomendasBean, int tipoLista) {
		List listaResultado = null;
		try{
			//Query con el Store Procedure
			String query = "call SEGTORECOMENDASLIS(?,?,?,?, ?,?,?,?,?,?,?);";
			Object[] parametros = {	segtoRecomendasBean.getDescripcion(),
									Constantes.STRING_VACIO,
									Constantes.STRING_VACIO,
									tipoLista,

									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.FECHA_VACIA,
									Constantes.STRING_VACIO,
									"SegtoRecomendasDAO.listaPrincipal",
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO
									};

			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call SEGTORECOMENDASLIS(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					SegtoRecomendasBean segtoRecomendasBean = new SegtoRecomendasBean();
					segtoRecomendasBean.setRecomendacionSegtoID(resultSet.getString("RecomendacionSegtoID"));
					segtoRecomendasBean.setDescripcion(resultSet.getString("Descripcion"));
					return segtoRecomendasBean;
				}
			});
			listaResultado =  matches;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en lista SEGTORECOMENDASLIS: " +e);
		}
		return listaResultado;
	}

	public SegtoRecomendasBean consultaRecomendaAlcance(SegtoRecomendasBean segtoRecomendasBean,int tipoConsulta) {
		SegtoRecomendasBean segto = new SegtoRecomendasBean();
		try{
			// Query con el Store Procedure
			String query = "call SEGTORECOMENDASCON(?,?, ?,?,?,?,?,?,?);";

			Object[] parametros = {
									segtoRecomendasBean.getRecomendacionSegtoID(),
									tipoConsulta,

									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.FECHA_VACIA,
									Constantes.STRING_VACIO,
									"SegtoManualDAO.consultaPrincipal",
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO
								};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call SEGTORECOMENDASCON(  " + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum)
						throws SQLException {
					SegtoRecomendasBean segtoRec = new SegtoRecomendasBean();
					segtoRec.setRecomendacionSegtoID(resultSet.getString(1));
					segtoRec.setAlcance(resultSet.getString(2));
					segtoRec.setReqSupervisor(resultSet.getString(3));
					return segtoRec;
				}
			});
			segto =  matches.size() > 0 ? (SegtoRecomendasBean) matches.get(0) : null;
		}catch(Exception e){
			e.printStackTrace();
		}
		return segto;
	}
}
