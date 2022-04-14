package cobranza.dao;

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

import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import cobranza.bean.AsignaCarteraBean;
import cobranza.bean.LiberaCarteraBean;
import cobranza.bean.RepLiberaCarteraBean;
import herramientas.Constantes;
import herramientas.OperacionesFechas;
import herramientas.Utileria;

public class LiberaCarteraDAO extends BaseDAO{
	private final static String salidaPantalla = "S";

	public LiberaCarteraDAO(){

	}

	public MensajeTransaccionBean liberaCredito(final LiberaCarteraBean liberaCartera,final List listaBean,final int tipoTransaccion) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					LiberaCarteraBean bean;

					if(listaBean!=null && listaBean.size() > 0){
						for(int i=0; i<listaBean.size(); i++){
							/* obtenemos un bean de la lista */
							bean = (LiberaCarteraBean)listaBean.get(i);

							bean.setFechaSis(liberaCartera.getFechaSis());
							bean.setUsuarioLogeadoID(liberaCartera.getUsuarioLogeadoID());

							mensajeBean = libCredAsignados(bean, tipoTransaccion);
							if(mensajeBean.getNumero()!=0){
								throw new Exception(mensajeBean.getDescripcion());
							}
						}
					}else{
						mensajeBean.setDescripcion("Error Lista de Creditos vacia");
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Lista de Creditos Liberados", e);
					if(mensajeBean.getNumero()==0){
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

	public MensajeTransaccionBean libCredAsignados(final LiberaCarteraBean detCredLib,final int tipoTransaccion) {
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
									String query = "call DETCOBCARTERAASIGACT(" +
													"?,?,?,?,?," +
													"?,?,?,?," +
													"?,?,?,?,?," +
													"?,?,?,?,?,?,?);";//parametros de auditoria
									CallableStatement sentenciaStore = arg0.prepareCall(query);
									sentenciaStore.setInt("Par_FolioAsigID",Utileria.convierteEntero(detCredLib.getAsignadoID()));
									sentenciaStore.setLong("Par_CreditoID",Utileria.convierteLong(detCredLib.getCreditoID()));
									sentenciaStore.setString("Par_EstatusCredLib",detCredLib.getEstatusCredLib());
									sentenciaStore.setInt("Par_DiasAtrasoLib",Utileria.convierteEntero(detCredLib.getDiasAtrasoLib()));
									sentenciaStore.setDouble("Par_SaldoCapitalLib",Utileria.convierteDoble(detCredLib.getSaldoCapitalLib()));

									sentenciaStore.setDouble("Par_SaldoInteresLib",Utileria.convierteDoble(detCredLib.getSaldoInteresLib()));
									sentenciaStore.setDouble("Par_SaldoMorarioLib",Utileria.convierteDoble(detCredLib.getSaldoMoratorioLib()));
									sentenciaStore.setString("Par_MotivoLib",detCredLib.getMotivoLiberacion());
									sentenciaStore.setDate("Par_FechaSis",OperacionesFechas.conversionStrDate(detCredLib.getFechaSis()));
									sentenciaStore.setInt("Par_UsuarioLogID",Utileria.convierteEntero(detCredLib.getUsuarioLogeadoID()));
									sentenciaStore.setInt("Par_NumAct",tipoTransaccion);

									sentenciaStore.setString("Par_Salida",salidaPantalla);
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
										mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
										mensajeTransaccion.setDescripcion(resultadosStore.getString(2));
										mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
										mensajeTransaccion.setConsecutivoString(resultadosStore.getString(4));

									}else{
										mensajeTransaccion.setNumero(999);
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .AsignaCarteraDAO.detCredAsignados");
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
							throw new Exception(Constantes.MSG_ERROR + " .AsignaCarteraDAO.detCredAsignados");
						}else if(mensajeBean.getNumero()!=0){
							throw new Exception(mensajeBean.getDescripcion());
						}
					} catch (Exception e) {
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en el alta de detalles asignacion de cartera" + e);
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
	}


	public List reporteCreditosLiberados(int tipoLista,LiberaCarteraBean liberaCartera){
		String query = "call COBCARTERALIBERAREP(?,?,?,	?,?,?,?,?,?,?);";
		Object[] parametros = {

				liberaCartera.getTipoGestor(),
				Utileria.convierteEntero(liberaCartera.getSucursalID()),
				Utileria.convierteEntero(liberaCartera.getGestorID()),

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"reporteCreditosLiberados",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
				};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call COBCARTERALIBERAREP(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				RepLiberaCarteraBean repLiberaCarteraBean = new RepLiberaCarteraBean();

				repLiberaCarteraBean.setGestorID(resultSet.getString("GestorID"));
				repLiberaCarteraBean.setNombreGestor(resultSet.getString("NombreGestor"));
				repLiberaCarteraBean.setTipoAsignacion(resultSet.getString("DescripcionTipAsig"));
				repLiberaCarteraBean.setFechaAsignacion(resultSet.getString("FechaAsignacion"));
				repLiberaCarteraBean.setClienteID(resultSet.getString("ClienteID"));

				repLiberaCarteraBean.setNombreCompleto(resultSet.getString("NombreCompleto"));
				repLiberaCarteraBean.setSucursalCliente(resultSet.getString("NombreSucursal"));
				repLiberaCarteraBean.setCreditoID(resultSet.getString("CreditoID"));
				repLiberaCarteraBean.setNombreProducto(resultSet.getString("DescProductoCred"));
				repLiberaCarteraBean.setTelefonoFijo(resultSet.getString("TelefonoFijo"));

				repLiberaCarteraBean.setTelefonoCelular(resultSet.getString("TelefonoCelular"));
				repLiberaCarteraBean.setDomicilio(resultSet.getString("Domicilio"));
				repLiberaCarteraBean.setNombreAval(resultSet.getString("NombreAval"));
				repLiberaCarteraBean.setDomicilioAval(resultSet.getString("DomicilioAval"));
				repLiberaCarteraBean.setTelefonoAval(resultSet.getString("TelefonoAval"));

				repLiberaCarteraBean.setMotivoLiberacion(resultSet.getString("MotivoLiberacion"));
				repLiberaCarteraBean.setFechaLiberacion(resultSet.getString("FechaLiberacion"));
				repLiberaCarteraBean.setUsuarioLiberacion(resultSet.getString("ClaveUsuario"));

				return repLiberaCarteraBean;
			}
		});
		return matches;
	}

	public List listaliberaCreditos(int tipoLista,LiberaCarteraBean liberaCartera){
		String query = "call LIBERACREDITOLIS(?,?, ?,?,?,?,?,?,?);";
		Object[] parametros = {
				Utileria.convierteEntero(liberaCartera.getAsignadoID()),
				tipoLista,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"listaliberaCreditos",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
				};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call LIBERACREDITOLIS(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				LiberaCarteraBean liberaCarteraBean = new LiberaCarteraBean();

				liberaCarteraBean.setClienteID(resultSet.getString("ClienteID"));
				liberaCarteraBean.setNombreCompleto(resultSet.getString("NombreCompleto"));
				liberaCarteraBean.setSucursalID(resultSet.getString("SucursalID"));
				liberaCarteraBean.setNombreSucursal(resultSet.getString("NombreSucursal"));
				liberaCarteraBean.setCreditoID(resultSet.getString("CreditoID"));

				liberaCarteraBean.setEstatusCred(resultSet.getString("EstatusCred"));
				liberaCarteraBean.setDiasAtraso(resultSet.getString("DiasAtraso"));
				liberaCarteraBean.setMontoCredito(resultSet.getString("MontoCredito"));
				liberaCarteraBean.setFechaDesembolso(resultSet.getString("FechaDesembolso"));
				liberaCarteraBean.setFechaVencimien(resultSet.getString("FechaVencimien"));

				liberaCarteraBean.setFechaProxVencim(resultSet.getString("FechaProxVencim"));
				liberaCarteraBean.setSaldoCapital(resultSet.getString("SaldoCapital"));
				liberaCarteraBean.setSaldoInteres(resultSet.getString("SaldoInteres"));
				liberaCarteraBean.setSaldoMoratorio(resultSet.getString("SaldoMoratorio"));

				liberaCarteraBean.setEstatusCredLib(resultSet.getString("EstatusCredLib"));
				liberaCarteraBean.setDiasAtrasoLib(resultSet.getString("DiasAtrasoLib"));
				liberaCarteraBean.setSaldoCapitalLib(resultSet.getString("SaldoCapitalLib"));
				liberaCarteraBean.setSaldoInteresLib(resultSet.getString("SaldoInteresLib"));
				liberaCarteraBean.setSaldoMoratorioLib(resultSet.getString("SaldoMoratorioLib"));

				liberaCarteraBean.setMotivoLiberacion(resultSet.getString("MotivoLiberacion"));
				liberaCarteraBean.setAsignado(resultSet.getString("Asignado"));

				return liberaCarteraBean;
			}
		});
		return matches;
	}

}
