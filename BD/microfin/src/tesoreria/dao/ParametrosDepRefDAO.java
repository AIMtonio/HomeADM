package tesoreria.dao;

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
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;
import org.springframework.transaction.support.TransactionTemplate;

import originacion.bean.SolicitudCreditoBean;

import tesoreria.bean.ParametrosDepRefBean;

import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

public class ParametrosDepRefDAO extends BaseDAO {

	public ParametrosDepRefDAO (){
		super();
	}

	public MensajeTransaccionBean modifica(final ParametrosDepRefBean paramDepRefBean){
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
								String query = "call PARAMDEPREFERMOD(?,?,?,?,?,?,?,?,?,	 ?,?,?,?,?,   ?,?,?,?,?,?,?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);
								
								sentenciaStore.setInt("Par_ConsecutivoID", Utileria.convierteEntero(paramDepRefBean.getConsecutivoID()));
								sentenciaStore.setInt("Par_TipoArchivo", Utileria.convierteEntero(paramDepRefBean.getTipoArchivo()));
								sentenciaStore.setString("Par_DescripcionArch", paramDepRefBean.getDescripcionArch());
								sentenciaStore.setString("Par_PagoCredAutom", paramDepRefBean.getPagoCredAutom());
								sentenciaStore.setString("Par_Exigible", paramDepRefBean.getExigible());
								sentenciaStore.setString("Par_Sobrante", paramDepRefBean.getSobrante());
								sentenciaStore.setString("Par_LecturaAutom", paramDepRefBean.getLecturaAutom());
								sentenciaStore.setString("Par_RutaArchivos", paramDepRefBean.getRutaArchivos());
								sentenciaStore.setInt("Par_TiempoLectura", Utileria.convierteEntero(paramDepRefBean.getTiempoLectura()));

								sentenciaStore.setString("Par_AplicaCobranzaRef", paramDepRefBean.getCobranzaRef());
								sentenciaStore.setInt("Par_ProducCreditoID", Utileria.convierteEntero(paramDepRefBean.getProductoCreditoID()));

								sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

										//Parametros de Auditoria
								sentenciaStore.setInt("Par_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
								sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
								sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
								sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
								sentenciaStore.setString("Aud_ProgramaID","ParametrosDepRefDAO.modifica");
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
									resultadosStore.beforeFirst();
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
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Modificación de los Parámetros de Depósitos Referenciados " + e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}



	//Consulta Principal Parametros de depositos Referenciados
		public ParametrosDepRefBean consultaPrincipal(ParametrosDepRefBean paramDepRefBean, int tipoConsulta) {
			//Query con el Store Procedure
			String query = "call PARAMDEPREFERCON(?,?, 	?,?,?,?,?,?,?);";
			Object[] parametros = {
									paramDepRefBean.getConsecutivoID(),
									tipoConsulta,
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.FECHA_VACIA,
									Constantes.STRING_VACIO,
									Constantes.STRING_VACIO,
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO
									};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PARAMDEPREFERCON(" + Arrays.toString(parametros) +")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
						
					ParametrosDepRefBean parametrosDepRefBean = new ParametrosDepRefBean();
						
						parametrosDepRefBean.setConsecutivoID(resultSet.getString("ConsecutivoID"));
						parametrosDepRefBean.setTipoArchivo(resultSet.getString("TipoArchivo"));
						parametrosDepRefBean.setDescripcionArch(resultSet.getString("DescripcionArch"));
						parametrosDepRefBean.setPagoCredAutom(resultSet.getString("PagoCredAutom"));
						parametrosDepRefBean.setExigible(resultSet.getString("Exigible"));
						parametrosDepRefBean.setSobrante(resultSet.getString("Sobrante"));
						parametrosDepRefBean.setLecturaAutom(resultSet.getString("LecturaAutom"));
						parametrosDepRefBean.setRutaArchivos(resultSet.getString("RutaArchivos"));
						parametrosDepRefBean.setTiempoLectura(resultSet.getString("TiempoLectura"));
						
					return parametrosDepRefBean;
				}
			});
			return matches.size() > 0 ? (ParametrosDepRefBean) matches.get(0) : null;
		}

		//Consulta Principal Parametros de CObranza Referenciados
		public ParametrosDepRefBean paramCobranzRef(ParametrosDepRefBean paramDepRefBean, int tipoConsulta) {
			tipoConsulta = 1;
			//Query con el Store Procedure
			String query = "call PARAMCOBRANZAREFERCON(?,?,?, 	?,?,?,?,?,?,?);";
			Object[] parametros = {
									paramDepRefBean.getConsecutivoID(),
									paramDepRefBean.getProductoCreditoID(),
									tipoConsulta,
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.FECHA_VACIA,
									Constantes.STRING_VACIO,
									Constantes.STRING_VACIO,
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO
									};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PARAMCOBRANZAREFERCON(" + Arrays.toString(parametros) +")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

					ParametrosDepRefBean parametrosDepRefBean = new ParametrosDepRefBean();

						parametrosDepRefBean.setParamCobranzaReferID(resultSet.getString("ParamCobranzaReferID"));
						parametrosDepRefBean.setConsecutivoID(resultSet.getString("ConsecutivoID"));
						parametrosDepRefBean.setCobranzaRef(resultSet.getString("AplicaCobranzaRef"));
						parametrosDepRefBean.setProductoCreditoID(resultSet.getString("ProducCreditoID"));

					return parametrosDepRefBean;
				}
			});
			return matches.size() > 0 ? (ParametrosDepRefBean) matches.get(0) : null;
		}

}
