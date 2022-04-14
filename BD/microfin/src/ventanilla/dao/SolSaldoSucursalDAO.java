package ventanilla.dao;

import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.CallableStatementCallback;
import org.springframework.jdbc.core.CallableStatementCreator;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;
import org.springframework.transaction.support.TransactionTemplate;

import herramientas.Constantes;
import herramientas.Utileria;
import ventanilla.bean.SolSaldoSucursalBean;
import general.bean.ParametrosAuditoriaBean;
import general.bean.ParametrosSesionBean;
import general.dao.BaseDAO;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.Arrays;
import java.util.List;

import general.bean.MensajeTransaccionBean;


public class SolSaldoSucursalDAO extends BaseDAO{
	public SolSaldoSucursalDAO(){
		super();
	}

	ParametrosSesionBean parametrosSesionBean = null;
	ParametrosAuditoriaBean parametrosAuditoriaBean = null;

	public MensajeTransaccionBean altaSolSaldoSucursal(final SolSaldoSucursalBean solSaldoSucursalBean){

		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			@SuppressWarnings("unchecked")
			public Object doInTransaction(TransactionStatus transaction) {

				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();

				try {

					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {

								String query = "call SOLSALDOSUCURSALALT  (?,?,?,?,?, ?,?,?,?,?,"
																		+ "?,?,?,?,?, ?,?,?,?,?,"
																		+ "?,?,?,?,?, ?);";//parametros de auditoria

									CallableStatement sentenciaStore = arg0.prepareCall(query);

									sentenciaStore.setInt("Par_UsuarioID", Utileria.convierteEntero(solSaldoSucursalBean.getUsuarioID()));
									sentenciaStore.setInt("Par_SucursalID",Utileria.convierteEntero(solSaldoSucursalBean.getSucursalID()));
									sentenciaStore.setInt("Par_CanCreDesem",Utileria.convierteEntero(solSaldoSucursalBean.getCanCreDesem()));
									sentenciaStore.setDouble("Par_MonCreDesem",Utileria.convierteDoble(solSaldoSucursalBean.getMonCreDesem()));
									sentenciaStore.setInt("Par_CanInverVenci",Utileria.convierteEntero(solSaldoSucursalBean.getCanInverVenci()));

									sentenciaStore.setDouble("Par_MonInverVenci",Utileria.convierteDoble(solSaldoSucursalBean.getMonInverVenci()));
									sentenciaStore.setInt("Par_CanChequeEmi",Utileria.convierteEntero(solSaldoSucursalBean.getCanChequeEmi()));
									sentenciaStore.setDouble("Par_MonChequeEmi",Utileria.convierteDoble(solSaldoSucursalBean.getMonChequeEmi()));
									sentenciaStore.setInt("Par_CanChequeIntReA",Utileria.convierteEntero(solSaldoSucursalBean.getCanChequeIntReA()));
									sentenciaStore.setDouble("Par_MonChequeIntReA",Utileria.convierteDoble(solSaldoSucursalBean.getMonChequeIntReA()));

									sentenciaStore.setInt("Par_CanChequeIntRe",Utileria.convierteEntero(solSaldoSucursalBean.getCanChequeIntRe()));
									sentenciaStore.setDouble("Par_MonChequeIntRe",Utileria.convierteDoble(solSaldoSucursalBean.getMonChequeIntRe()));
									sentenciaStore.setDouble("Par_SaldosCP",Utileria.convierteDoble(solSaldoSucursalBean.getSaldosCP()));
									sentenciaStore.setDouble("Par_SaldosCA",Utileria.convierteDoble(solSaldoSucursalBean.getSaldosCA()));
									sentenciaStore.setDouble("Par_MontoSolicitado",Utileria.convierteDoble(solSaldoSucursalBean.getMontoSolicitado()));

									sentenciaStore.setString("Par_Comentarios",solSaldoSucursalBean.getComentarios());

									sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
									//Parametros de Auditoria
									sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
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
										mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString("NumErr")).intValue());
										mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
										mensajeTransaccion.setNombreControl(resultadosStore.getString("Control"));
										mensajeTransaccion.setConsecutivoString(resultadosStore.getString("Consecutivo"));

									}else{

										mensajeTransaccion.setNumero(999);
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .SolSaldoSucursalDAO.altaSolSaldoSucursal");
										mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
										mensajeTransaccion.setConsecutivoString(Constantes.STRING_VACIO);
										mensajeTransaccion.setCampoGenerico(Constantes.STRING_CERO);
									}

									return mensajeTransaccion;
								}
							}
							);

						if(mensajeBean ==  null){

							mensajeBean = new MensajeTransaccionBean();
							mensajeBean.setNumero(999);
							throw new Exception(Constantes.MSG_ERROR + " .SolSaldoSucursalDAO.altaSolSaldoSucursal");
						}else if(mensajeBean.getNumero()!=0){

							throw new Exception(mensajeBean.getDescripcion());

						}
					} catch (Exception e) {

						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Alta de Solicitud de Saldo por Sucursal" + e);
						e.printStackTrace();
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
	};

	public SolSaldoSucursalBean consultaPrincipal(SolSaldoSucursalBean solSaldoSucursalBean, int tipoConsulta){
		String query = "call SOLSALDOSUCURSALCON(?,?,?,?,?,?,?,?,?,?);";
		Object[] parametros = { solSaldoSucursalBean.getUsuarioID(),
								solSaldoSucursalBean.getSucursalID(),
								tipoConsulta,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								Constantes.STRING_VACIO,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO };
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call SOLSALDOSUCURSALCON(  " + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				SolSaldoSucursalBean solSaldoSucursalBean = new SolSaldoSucursalBean();

				solSaldoSucursalBean.setCanCreDesem(resultSet.getString("CanCreDesem"));
				solSaldoSucursalBean.setMonCreDesem(resultSet.getString("MonCreDesem"));
				solSaldoSucursalBean.setCanInverVenci(resultSet.getString("CanInverVenci"));
				solSaldoSucursalBean.setMonInverVenci(resultSet.getString("MonInverVenci"));
				solSaldoSucursalBean.setCanChequeEmi(resultSet.getString("CanChequeEmi"));
				solSaldoSucursalBean.setMonChequeEmi(resultSet.getString("MonChequeEmi"));
				solSaldoSucursalBean.setCanChequeIntReA(resultSet.getString("CanChequeIntReA"));
				solSaldoSucursalBean.setMonChequeIntReA(resultSet.getString("MonChequeIntReA"));
				solSaldoSucursalBean.setCanChequeIntRe(resultSet.getString("CanChequeIntRe"));
				solSaldoSucursalBean.setMonChequeIntRe(resultSet.getString("MonChequeIntRe"));
				solSaldoSucursalBean.setSaldosCP(resultSet.getString("SaldosCP"));
				solSaldoSucursalBean.setSaldosCA(resultSet.getString("SaldosCA"));

				solSaldoSucursalBean.setMontoSolicitado(resultSet.getString("MontoSolicitado"));
				solSaldoSucursalBean.setComentarios(resultSet.getString("Comentarios"));

				return solSaldoSucursalBean;
			}
		});
		return matches.size() > 0 ? (SolSaldoSucursalBean) matches.get(0) : null;
	}

	public List reporteSolicitudSaldo(int tipoLista,SolSaldoSucursalBean solSaldoSucursalBean){
		String query = "call SOLSALDOSUCURSALREP(?,?,?, ?,?,?,?,?,?,?);";
		String fechaIni=solSaldoSucursalBean.getFechaIni();
		String fechaFin=solSaldoSucursalBean.getFechaFin();
		String sucursal=solSaldoSucursalBean.getSucursalID();
		Object[] parametros = {
				fechaIni,
				fechaFin,
				sucursal,
				//Parametros de Auditoria
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"reporteSolSaldoSucursal",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
				};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call SOLSALDOSUCURSALREP(" + Arrays.toString(parametros) + ")");
		@SuppressWarnings({ "rawtypes", "unchecked" })
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				SolSaldoSucursalBean repSaldoSucursalBean =new SolSaldoSucursalBean();

				repSaldoSucursalBean.setSucursalID(resultSet.getString("SucursalID"));
				repSaldoSucursalBean.setSucursalNom(resultSet.getString("NombreSucurs"));
				repSaldoSucursalBean.setCuentas(resultSet.getString("Cuentas"));
				repSaldoSucursalBean.setUsuarioID(resultSet.getString("UsuarioID"));
				repSaldoSucursalBean.setFechaSol(resultSet.getString("FechaSolicitud"));
				repSaldoSucursalBean.setHora(resultSet.getString("HoraSolicitud"));
				repSaldoSucursalBean.setCanCreDesem(resultSet.getString("CanCreDesem"));
				repSaldoSucursalBean.setMonCreDesem(resultSet.getString("MonCreDesem"));
				repSaldoSucursalBean.setCanInverVenci(resultSet.getString("CanInverVenci"));
				repSaldoSucursalBean.setMonInverVenci(resultSet.getString("MonInverVenci"));
				repSaldoSucursalBean.setCanChequeEmi(resultSet.getString("CanChequeEmi"));
				repSaldoSucursalBean.setMonChequeEmi(resultSet.getString("MonChequeEmi"));
				repSaldoSucursalBean.setCanChequeIntReA(resultSet.getString("CanChequeIntReA"));
				repSaldoSucursalBean.setMonChequeIntReA(resultSet.getString("MonChequeIntReA"));
				repSaldoSucursalBean.setCanChequeIntRe(resultSet.getString("CanChequeIntRe"));
				repSaldoSucursalBean.setMonChequeIntRe(resultSet.getString("MonChequeIntRe"));
				repSaldoSucursalBean.setSaldosCP(resultSet.getString("SaldosCP"));
				repSaldoSucursalBean.setSaldosCA(resultSet.getString("SaldosCA"));
				repSaldoSucursalBean.setMontoSolicitado(resultSet.getString("MontoSolicitado"));
				repSaldoSucursalBean.setComentarios(resultSet.getString("Comentarios"));

				return repSaldoSucursalBean;

			}

			});
		return matches;

	}

	public ParametrosSesionBean getParametrosSesionBean() {
		return parametrosSesionBean;
	}

	public void setParametrosSesionBean(ParametrosSesionBean parametrosSesionBean) {
		this.parametrosSesionBean = parametrosSesionBean;
	}

	public ParametrosAuditoriaBean getParametrosAuditoriaBean() {
		return parametrosAuditoriaBean;
	}

	public void setParametrosAuditoriaBean(
			ParametrosAuditoriaBean parametrosAuditoriaBean) {
		this.parametrosAuditoriaBean = parametrosAuditoriaBean;
	}





}
