package seguimiento.dao;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;

import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.OperacionesFechas;
import herramientas.Utileria;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.CallableStatementCallback;
import org.springframework.jdbc.core.CallableStatementCreator;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;

import credito.bean.EsquemaComPrepagoCreditoBean;
import credito.dao.ProductosCreditoDAO;

import seguimiento.bean.ResultadoSegtoCobranzaBean;

import seguimiento.bean.TiposGestoresBean;

public class ResultadoSegtoCobranzaDAO extends BaseDAO{

	public ResultadoSegtoCobranzaDAO(){
		super();
	}

	public MensajeTransaccionBean alta(final ResultadoSegtoCobranzaBean resultadoSegtoCobranzaBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								resultadoSegtoCobranzaBean.setTelefonFijo(resultadoSegtoCobranzaBean.getTelefonFijo().trim().replaceAll("\\(","").replaceAll("\\)","").replaceAll(" ","").replaceAll("\\-",""));
								resultadoSegtoCobranzaBean.setTelefonCel(resultadoSegtoCobranzaBean.getTelefonCel().trim().replaceAll("\\(","").replaceAll("\\)","").replaceAll(" ","").replaceAll("\\-",""));

								String query = "call SEGTORESCOBRAORDALT(?,?,?,?,?,  ?,?,?,?,?,  ?,?,?,?,?, ?,?,?,?,?,?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);
								sentenciaStore.setInt("Par_SegtoPrograID",Utileria.convierteEntero(resultadoSegtoCobranzaBean.getSegtoPrograID()));
								sentenciaStore.setInt("Par_SegtoRealizaID",Utileria.convierteEntero(resultadoSegtoCobranzaBean.getSegtoRealizaID()));
								sentenciaStore.setString("Par_FechaPromPago",(resultadoSegtoCobranzaBean.getFechaPromPago() == "" ? Constantes.FECHA_VACIA :  resultadoSegtoCobranzaBean.getFechaPromPago()));
								sentenciaStore.setDouble("Par_MontoPromPago",Utileria.convierteDoble(resultadoSegtoCobranzaBean.getMontoPromPago()));
								sentenciaStore.setString("Par_ExistFlujo",resultadoSegtoCobranzaBean.getExistFlujo());
								sentenciaStore.setString("Par_FechaEstFlujo",(resultadoSegtoCobranzaBean.getFechaEstFlujo() == "" ? Constantes.FECHA_VACIA : resultadoSegtoCobranzaBean.getFechaEstFlujo()));
								sentenciaStore.setInt("Par_OrigenPagoID",(resultadoSegtoCobranzaBean.getOrigenPagoID() == "" ? Constantes.ENTERO_CERO : Utileria.convierteEntero(resultadoSegtoCobranzaBean.getOrigenPagoID())));
								sentenciaStore.setInt("Par_MotivoNPID",(resultadoSegtoCobranzaBean.getMotivoNPID() == "" ? Constantes.ENTERO_CERO : Utileria.convierteEntero(resultadoSegtoCobranzaBean.getMotivoNPID())));
								sentenciaStore.setString("Par_NomOriRecursos",resultadoSegtoCobranzaBean.getNomOriRecursos());
								sentenciaStore.setString("Par_TelefonFijo",resultadoSegtoCobranzaBean.getTelefonFijo());
								sentenciaStore.setString("Par_TelefonCel",resultadoSegtoCobranzaBean.getTelefonCel());
								sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

								sentenciaStore.setInt("Par_Empresa",parametrosAuditoriaBean.getEmpresaID());
								sentenciaStore.setInt("Par_Usuario", parametrosAuditoriaBean.getUsuario());
								sentenciaStore.setDate("Par_FechaActual", parametrosAuditoriaBean.getFecha());
								sentenciaStore.setString("Par_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
								sentenciaStore.setString("Par_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
								sentenciaStore.setInt("Par_SucursalID",parametrosAuditoriaBean.getSucursal());
								sentenciaStore.setLong("Par_NumTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());

								loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString()+":::");
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
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta captura de cobranza de seguimiento ", e);
					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	//MODIFICACION
	public MensajeTransaccionBean modifica(final ResultadoSegtoCobranzaBean resultadoSegtoCobranzaBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								resultadoSegtoCobranzaBean.setTelefonFijo(resultadoSegtoCobranzaBean.getTelefonFijo().trim().replaceAll("\\(","").replaceAll("\\)","").replaceAll(" ","").replaceAll("\\-",""));
								resultadoSegtoCobranzaBean.setTelefonCel(resultadoSegtoCobranzaBean.getTelefonCel().trim().replaceAll("\\(","").replaceAll("\\)","").replaceAll(" ","").replaceAll("\\-",""));

								String query = "call SEGTORESCOBRAORDMOD(?,?,?,?,?,  ?,?,?,?,?,  ?,?,?,?,?, ?,?,?,?,?,?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);
								sentenciaStore.setInt("Par_SegtoPrograID",Utileria.convierteEntero(resultadoSegtoCobranzaBean.getSegtoPrograID()));
								sentenciaStore.setInt("Par_SegtoRealizaID",Utileria.convierteEntero(resultadoSegtoCobranzaBean.getSegtoRealizaID()));
								sentenciaStore.setString("Par_FechaPromPago",(resultadoSegtoCobranzaBean.getFechaPromPago() == "" ? Constantes.FECHA_VACIA : resultadoSegtoCobranzaBean.getFechaPromPago()));
								sentenciaStore.setDouble("Par_MontoPromPago",Utileria.convierteDoble(resultadoSegtoCobranzaBean.getMontoPromPago()));
								sentenciaStore.setString("Par_ExistFlujo",resultadoSegtoCobranzaBean.getExistFlujo());
								sentenciaStore.setString("Par_FechaEstFlujo",(resultadoSegtoCobranzaBean.getFechaEstFlujo() == "" ? Constantes.FECHA_VACIA : resultadoSegtoCobranzaBean.getFechaEstFlujo()));
								sentenciaStore.setInt("Par_OrigenPagoID",(resultadoSegtoCobranzaBean.getOrigenPagoID() == "" ? Constantes.ENTERO_CERO : Utileria.convierteEntero(resultadoSegtoCobranzaBean.getOrigenPagoID())));
								sentenciaStore.setInt("Par_MotivoNPID",(resultadoSegtoCobranzaBean.getMotivoNPID() == "" ? Constantes.ENTERO_CERO : Utileria.convierteEntero(resultadoSegtoCobranzaBean.getMotivoNPID())));
								sentenciaStore.setString("Par_NomOriRecursos",resultadoSegtoCobranzaBean.getNomOriRecursos());
								sentenciaStore.setString("Par_TelefonFijo",resultadoSegtoCobranzaBean.getTelefonFijo());
								sentenciaStore.setString("Par_TelefonCel",resultadoSegtoCobranzaBean.getTelefonCel());
								sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

								sentenciaStore.setInt("Par_Empresa",parametrosAuditoriaBean.getEmpresaID());
								sentenciaStore.setInt("Par_Usuario", parametrosAuditoriaBean.getUsuario());
								sentenciaStore.setDate("Par_FechaActual", parametrosAuditoriaBean.getFecha());
								sentenciaStore.setString("Par_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
								sentenciaStore.setString("Par_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
								sentenciaStore.setInt("Par_SucursalID",parametrosAuditoriaBean.getSucursal());
								sentenciaStore.setLong("Par_NumTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());

								loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString()+":::");
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
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en Modificacion De captura de seguimiento de cobranza", e);
					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	//consulta Principal
	public ResultadoSegtoCobranzaBean consultaPrincipal(ResultadoSegtoCobranzaBean resultadoSegtoCobranzaBean, int tipoConsulta) {
		ResultadoSegtoCobranzaBean resultadoSegtoCobranzaConsulta = new ResultadoSegtoCobranzaBean();
			try{
				//Query con el Store Procedure
				String query = "call SEGTORESCOBRAORDCON(?,? ,?,  ?,?,?,?,?,?,?);";
				Object[] parametros = { Utileria.convierteEntero(resultadoSegtoCobranzaBean.getSegtoPrograID()),
										Utileria.convierteEntero(resultadoSegtoCobranzaBean.getSegtoRealizaID()),
										tipoConsulta,

										Constantes.ENTERO_CERO,
										Constantes.ENTERO_CERO,
										Constantes.FECHA_VACIA,
										Constantes.STRING_VACIO,
										"EsquemaComPrepagoCreditoDAO.consultaPrincipal",
										Constantes.ENTERO_CERO,
										Constantes.ENTERO_CERO};
				loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call SEGTORESCOBRAORDCON(  " + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
					public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
						ResultadoSegtoCobranzaBean resultadoSegtoCobranza = new ResultadoSegtoCobranzaBean();
						resultadoSegtoCobranza.setSegtoPrograID(String.valueOf(resultSet.getInt("SegtoPrograID")));
						resultadoSegtoCobranza.setSegtoRealizaID(String.valueOf(resultSet.getInt("SegtoRealizaID")));
						resultadoSegtoCobranza.setFechaPromPago(resultSet.getString("FechaPromPago"));
						resultadoSegtoCobranza.setMontoPromPago(String.valueOf(resultSet.getDouble("MontoPromPago")));
						resultadoSegtoCobranza.setExistFlujo(resultSet.getString("ExistFlujo"));
						resultadoSegtoCobranza.setFechaEstFlujo(String.valueOf(resultSet.getString("FechaEstFlujo")));
						resultadoSegtoCobranza.setOrigenPagoID(String.valueOf(resultSet.getString("OrigenPagoID")));
						resultadoSegtoCobranza.setMotivoNPID(resultSet.getString("MotivoNPID"));
						resultadoSegtoCobranza.setNomOriRecursos(resultSet.getString("NombreOriRecursos"));
						resultadoSegtoCobranza.setTelefonFijo(String.valueOf(resultSet.getString("TelefonoFijo")));
						resultadoSegtoCobranza.setTelefonCel(String.valueOf(resultSet.getString("TelefonoCel")));
		            	return resultadoSegtoCobranza;
					}
				});
				resultadoSegtoCobranzaBean= matches.size() > 0 ? (ResultadoSegtoCobranzaBean) matches.get(0) : null;
			}catch(Exception e){
				e.printStackTrace();
				loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en consulta principal", e);
			}
			return resultadoSegtoCobranzaBean;
		}
}
