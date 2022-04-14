package ventanilla.dao;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;

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

import ventanilla.bean.AbonoChequeSBCBean;
import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.OperacionesFechas;
import herramientas.Utileria;

public class AbonoChequeSBCDAO extends BaseDAO{


	public AbonoChequeSBCDAO(){
		super();
	}



	public MensajeTransaccionBean aplicaChequeDepositoCuenta(final AbonoChequeSBCBean abonoChequeSBCBean) {
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
						String query = "call CHEQUESBCDEPBANPRO(?,?,?,?,?, ?,?,?,?,?,  ?,?,?,?);";

								CallableStatement sentenciaStore = arg0.prepareCall(query);
								sentenciaStore.setInt("Par_ChequeSBCID",Utileria.convierteEntero(abonoChequeSBCBean.getChequeSBCID()));
								sentenciaStore.setInt("Par_SucOperacion",Utileria.convierteEntero(abonoChequeSBCBean.getSucursalOperacion()));
								sentenciaStore.setInt("Par_InstitucionID",Utileria.convierteEntero(abonoChequeSBCBean.getBancoAplica()));
								sentenciaStore.setString("Par_CuentaBancos",abonoChequeSBCBean.getCuentaBancoAplica());

								sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

								sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
								sentenciaStore.setInt("Aud_Usuario",parametrosAuditoriaBean.getUsuario());
								sentenciaStore.setDate("Aud_FechaActual",parametrosAuditoriaBean.getFecha());
								sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
								sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
								sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
								sentenciaStore.setLong("Aud_NumTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());

								loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());
								return sentenciaStore;
							} //public sql exception
						} // new CallableStatementCreator
						,new CallableStatementCallback() {
							public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,
																											DataAccessException {
								MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
								if(callableStatement.execute()){
									ResultSet resultadosStore = callableStatement.getResultSet();
									 resultadosStore.next();

									mensajeTransaccion.setNumero(Utileria.convierteEntero(resultadosStore.getString("NumErr")));
									mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
									mensajeTransaccion.setNombreControl(resultadosStore.getString("control"));
									mensajeTransaccion.setConsecutivoString(resultadosStore.getString("consecutivo"));
								}else{
									mensajeTransaccion.setNumero(999);
									mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.");
								}
								return mensajeTransaccion;
							}// public
						}// CallableStatementCallback
						);
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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error Aplicación de cheque SBC con deposito a cuenta", e);
				mensajeBean.setDescripcion(e.getMessage());
				transaction.setRollbackOnly();

				}
				return mensajeBean;
			}
		});
		return mensaje;
	}


	public AbonoChequeSBCBean consultaPrincipal(final AbonoChequeSBCBean abonoChequeSBCBean, int tipoConsulta) {
		List matches= null;
		try{
		String query = "call ABONOCHEQUESBCCON(?,?,?,?,?, ?, ?,?,?,?,?,?,?);";
		Object[] parametros = {
								abonoChequeSBCBean.getChequeSBCID(),
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.STRING_VACIO,
								tipoConsulta,

								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"AbonoChequeSBCDAO.consultaPrincipal",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO
							};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call ABONOCHEQUESBCCON(" + Arrays.toString(parametros) + ")");
		matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				AbonoChequeSBCBean abonoChequeSBCB = new AbonoChequeSBCBean();

				abonoChequeSBCB.setChequeSBCID(resultSet.getString("ChequeSBCID"));
				abonoChequeSBCB.setCuentaAhoID(resultSet.getString("CuentaAhoID"));
				abonoChequeSBCB.setClienteID(resultSet.getString("ClienteID"));
				abonoChequeSBCB.setNombreReceptor(resultSet.getString("NombreReceptor"));
				abonoChequeSBCB.setEstatus(resultSet.getString("Estatus"));

				abonoChequeSBCB.setMonto(resultSet.getString("Monto"));
				abonoChequeSBCB.setBancoEmisor(resultSet.getString("BancoEmisor"));
				abonoChequeSBCB.setCuentaEmisor(resultSet.getString("CuentaEmisor"));
				abonoChequeSBCB.setNumCheque(resultSet.getString("NumCheque"));
				abonoChequeSBCB.setNombreEmisor(resultSet.getString("NombreEmisor"));
				abonoChequeSBCB.setSucursalID(resultSet.getString("SucursalID"));

				abonoChequeSBCB.setCajaID(resultSet.getString("CajaID"));
				abonoChequeSBCB.setFechaCobro(resultSet.getString("FechaCobro"));
				abonoChequeSBCB.setFechaAplicacion(resultSet.getString("FechaAplicacion"));
				abonoChequeSBCB.setUsuarioID(resultSet.getString("UsuarioID"));


				return abonoChequeSBCB;
			}
		});
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en consulta principal de cheques SBC", e);
		}
		return matches.size() > 0 ? (AbonoChequeSBCBean) matches.get(0) : null;
	}

	public List listaChequesSBC(int tipoLista, AbonoChequeSBCBean abonoChequeSBCBean) {
		List listaCheques = null;

		try{
			//Query con el Store Procedure
			String query = "call ABONOCHEQUESBCLIS(?,?,?,?,?,?,  ?,?,?,?,?,  ?,?,?,?,?,   ?);";
			Object[] parametros = {
					Constantes.ENTERO_CERO,
					abonoChequeSBCBean.getCuentaAhoID(),
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.STRING_VACIO,
					Constantes.STRING_VACIO,
					Constantes.ENTERO_CERO,
					Constantes.STRING_VACIO,
					Constantes.FECHA_VACIA,
					tipoLista,

					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					"AbonoChequeSBCDAO.listaChequesSBC",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO
					};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call ABONOCHEQUESBCLIS(" + Arrays.toString(parametros)  +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					AbonoChequeSBCBean abonoChequeSBCBean = new AbonoChequeSBCBean();
					abonoChequeSBCBean.setChequeSBCID(resultSet.getString(1));
					abonoChequeSBCBean.setNumCheque(resultSet.getString(2));
					return abonoChequeSBCBean;
				}
			});
			listaCheques =  matches;
		}catch(Exception e){
			e.printStackTrace();
		}
		return listaCheques ;
	}


	public List <AbonoChequeSBCBean> listaRepcheques(AbonoChequeSBCBean reporteCheques) {
		List <AbonoChequeSBCBean> listaCheques = null;
		try{
			String query = "call CHEQUESBCREP(?,?,?,?,?, ?,?,?,"
											  + "?,?,?,?,?,?,?);";
			Object[] parametros = {
									reporteCheques.getFechaCobro(),
									reporteCheques.getFechaFinCobro(),
									reporteCheques.getBancoEmisor(),
									reporteCheques.getCuentaEmisor(),
									reporteCheques.getNumCheque(),
									reporteCheques.getEstatus(),
									reporteCheques.getClienteID(),
									reporteCheques.getSucursalID(),



									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									OperacionesFechas.FEC_VACIA,
									Constantes.STRING_VACIO,
									"CHEQUESBCREP",
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CHEQUESBCREP(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {

				public Object mapRow(ResultSet resultSet, int rowNum)
						throws SQLException {
					AbonoChequeSBCBean reporteCheques = new AbonoChequeSBCBean();
					reporteCheques.setSucursalID(resultSet.getString("SucursalID"));
					reporteCheques.setNombreSucurs(resultSet.getString("NombreSucurs"));
					reporteCheques.setTipoCheque(resultSet.getString("TipoCheque"));
					reporteCheques.setBancoEmisor(resultSet.getString("BancoEmisor"));
					reporteCheques.setNombreCorto(resultSet.getString("NombreCorto"));
					reporteCheques.setCuentaEmisor(resultSet.getString("CuentaEmisor"));
					reporteCheques.setNumCheque(resultSet.getString("NumCheque"));
					reporteCheques.setClienteID(resultSet.getString("ClienteID"));
					reporteCheques.setNombreReceptor(resultSet.getString("NombreReceptor"));
					reporteCheques.setMonto(resultSet.getString("Monto"));
					reporteCheques.setFechaCobro(resultSet.getString("FechaRecepcion"));
					reporteCheques.setEstatus(resultSet.getString("EstatusCheque"));

					return reporteCheques;
				}

			});

			listaCheques = matches;
		}catch(Exception e){
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en lista de Movimientos de Cajas", e);

		}
		return listaCheques;
	}




	public List listaNumCheques(AbonoChequeSBCBean abonoChequeSBCBean, int tipoLista) {
		List listaCheques = null;
		try{
			//Query con el Store Procedure
			String query = "call ABONOCHEQUESBCLIS(?,?,?,?,?,?,   ?,?,?,?,?,   ?,?,?,?,?,?);";
			Object[] parametros = {
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									abonoChequeSBCBean.getInstitucionID(),
									Constantes.STRING_VACIO,
									abonoChequeSBCBean.getNombreReceptor(),
									abonoChequeSBCBean.getSucursalRep(),
									abonoChequeSBCBean.getTipoCheque(),
									abonoChequeSBCBean.getFechaCobro(),
									tipoLista,

									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.FECHA_VACIA,
									Constantes.STRING_VACIO,
									"AbonoChequeSBCDAO.List_NumCheque",
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO
									};

			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call ABONOCHEQUESBCLIS(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					AbonoChequeSBCBean abonoChequeSBCBean = new AbonoChequeSBCBean();
					abonoChequeSBCBean.setNumCheque(resultSet.getString("NumCheque"));
					abonoChequeSBCBean.setNombreReceptor(resultSet.getString("NombreReceptor"));
					return abonoChequeSBCBean;
				}
			});
			listaCheques =  matches;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en lista SEGTORESULTADOSLIS: " +e);
		}
		return listaCheques;
	}


	public List listaNumChequesSBC(AbonoChequeSBCBean abonoChequeSBCBean, int tipoLista) {
		List listaCheques = null;
		try{
			//Query con el Store Procedure
			String query = "call ABONOCHEQUESBCLIS(?,?,?,?,?,?,   ?,?,?,?,?,   ?,?,?,?,?,?);";
			Object[] parametros = {
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									abonoChequeSBCBean.getInstitucionID(),
									abonoChequeSBCBean.getCuentaEmisor(),
									abonoChequeSBCBean.getNombreReceptor(),
									Constantes.ENTERO_CERO,
									Constantes.STRING_VACIO,
									Constantes.FECHA_VACIA,
									tipoLista,

									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.FECHA_VACIA,
									Constantes.STRING_VACIO,
									"AbonoChequeSBCDAO.List_NumChequeSBC",
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO
									};

			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call ABONOCHEQUESBCLIS(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					AbonoChequeSBCBean abonoChequeSBCBean = new AbonoChequeSBCBean();
					abonoChequeSBCBean.setNumCheque(resultSet.getString("NumCheque"));
					abonoChequeSBCBean.setNombreReceptor(resultSet.getString("NombreReceptor"));
					return abonoChequeSBCBean;
				}
			});
			listaCheques =  matches;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en lista SEGTORESULTADOSLIS: " +e);
		}
		return listaCheques;
	}
}
