package operacionesCRCB.dao;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.Arrays;
import java.util.List;

import operacionesCRCB.bean.ConMovimientosCuentaBean;
import operacionesCRCB.beanWS.request.ConMovimientosCuentaRequest;
import operacionesCRCB.beanWS.response.ConMovimientosCuentaResponse;

import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.CallableStatementCallback;
import org.springframework.jdbc.core.CallableStatementCreator;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;
import org.springframework.transaction.support.TransactionTemplate;

import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

public class ConMovimientosCuentaDAO extends BaseDAO{

	public ConMovimientosCuentaDAO (){
		super();
	}

	public  ConMovimientosCuentaResponse consultaSaldoWS(final ConMovimientosCuentaRequest requestBean){
		ConMovimientosCuentaResponse consultaSal=new ConMovimientosCuentaResponse();

		consultaSal=(ConMovimientosCuentaResponse)((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			@SuppressWarnings("unchecked")
			public Object doInTransaction(TransactionStatus transaction) {
				ConMovimientosCuentaResponse resultado = new ConMovimientosCuentaResponse();
				transaccionDAO.generaNumeroTransaccion();
				try{
					resultado=(ConMovimientosCuentaResponse) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(

							new CallableStatementCreator() {

								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call CRCBCUENTASAHOWSPRO(?,?,?,?,?, ?,?,?,?,?, ?,?,?);";


									CallableStatement sentenciaStore = arg0.prepareCall(query);

									sentenciaStore.setLong("Par_CuentaAhoID",Utileria.convierteLong(requestBean.getCuentaAhoID()));
									sentenciaStore.setInt("Par_Anio",Utileria.convierteEntero(requestBean.getAnio()));
									sentenciaStore.setInt("Par_Mes",Utileria.convierteEntero(requestBean.getMes()));

									sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

									//Parametros de Auditoria
									sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
									sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
									sentenciaStore.setString("Aud_FechaActual", Constantes.FECHA_VACIA);
									sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
									sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());

									sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
									sentenciaStore.setLong("Aud_NumTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());

									loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());

									return sentenciaStore;
								}

							}, new CallableStatementCallback(){
								public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,
								                                                                                 DataAccessException {
									ConMovimientosCuentaResponse respuestaBean=new ConMovimientosCuentaResponse();
									if(callableStatement.execute()){
										ResultSet resultadosStore = callableStatement.getResultSet();

										resultadosStore.next();

										respuestaBean.setSaldoInicialMes(resultadosStore.getString("SaldoInicialMes"));
										respuestaBean.setAbonosMes(resultadosStore.getString("AbonosMes"));
										respuestaBean.setCargosMes(resultadosStore.getString("CargosMes"));
										respuestaBean.setSaldoDisponible(resultadosStore.getString("SaldoDisponible"));
										respuestaBean.setCodigoRespuesta(resultadosStore.getString("NumErr"));
     									respuestaBean.setMensajeRespuesta(resultadosStore.getString("ErrMen"));

									}else{
										respuestaBean.setSaldoInicialMes(String.valueOf(Constantes.ENTERO_CERO));
										respuestaBean.setAbonosMes(String.valueOf(Constantes.ENTERO_CERO));
										respuestaBean.setCargosMes(String.valueOf(Constantes.ENTERO_CERO));
										respuestaBean.setSaldoDisponible(String.valueOf(Constantes.ENTERO_CERO));
										respuestaBean.setCodigoRespuesta("999");
										respuestaBean.setMensajeRespuesta(Constantes.MSG_ERROR + " .ConMovimientosCuentaDAO.consultaSaldoWS");


									}
									return respuestaBean;
								}
							}
						);

						if(resultado ==  null){
							resultado = new ConMovimientosCuentaResponse();

							resultado.setSaldoInicialMes(String.valueOf(Constantes.ENTERO_CERO));
							resultado.setAbonosMes(String.valueOf(Constantes.ENTERO_CERO));
							resultado.setCargosMes(String.valueOf(Constantes.ENTERO_CERO));
							resultado.setSaldoDisponible(String.valueOf(Constantes.ENTERO_CERO));
							resultado.setCodigoRespuesta("999");
							resultado.setMensajeRespuesta("Error en la Base de Datos");

							throw new Exception(Constantes.MSG_ERROR + " .ConMovimientosCuenta.consultaSaldoWS");
						}

					} catch (Exception e) {

						transaction.setRollbackOnly();
						e.printStackTrace();
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en la consulta al WS", e);
					}
					return resultado;
			}
		});

		return consultaSal;
	}

	/* Lista de Movimientos de Cuentas para WS */
	@SuppressWarnings("unchecked")
	public List listaMovimientoCtaWS(int tipoLista,ConMovimientosCuentaRequest bean){
		List cuentasLis = null;
		try{
			String query = "call CRCBCUENTASAHOMOVWSLIS(?,?,?,?,?,  ?,?,?,?,?, ?);";
			Object[] parametros = {
									Utileria.convierteLong(bean.getCuentaAhoID()),
									Utileria.convierteEntero(bean.getAnio()),
									Utileria.convierteEntero(bean.getMes()),
									tipoLista,

									parametrosAuditoriaBean.getEmpresaID(),
									parametrosAuditoriaBean.getUsuario(),
									parametrosAuditoriaBean.getFecha(),
									parametrosAuditoriaBean.getDireccionIP(),
									"ConMovimientosCuentaDAO.listaMovimientoCtaWS",
									parametrosAuditoriaBean.getSucursal(),
									Constantes.ENTERO_CERO};

			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CUENTASAHOMOVCRCBWSLIS(" + Arrays.toString(parametros) +")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum)throws SQLException {
					ConMovimientosCuentaBean cuenta = new ConMovimientosCuentaBean();

					cuenta.setFecha(resultSet.getString("Fecha"));
					cuenta.setDescripcion(resultSet.getString("Descripcion"));
					cuenta.setNaturaleza(resultSet.getString("Naturaleza"));
					cuenta.setReferencia(resultSet.getString("Referencia"));
					cuenta.setMonto(resultSet.getString("Monto"));
					cuenta.setSaldo(resultSet.getString("Saldo"));

					return cuenta;
				}
			});

			cuentasLis = matches;
		}catch(Exception e){
			 e.printStackTrace();
			 loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Lista de Movimientos de Cuentas", e);
		}
		return cuentasLis;
	}// fin de lista para WS

}
