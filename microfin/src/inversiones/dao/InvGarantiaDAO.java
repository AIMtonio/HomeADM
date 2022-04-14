package inversiones.dao;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;

import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;
import inversiones.bean.InvGarantiaBean;
import contabilidad.bean.PolizaBean;
import contabilidad.dao.PolizaDAO;

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


public class InvGarantiaDAO extends BaseDAO{

	PolizaDAO polizaDAO = null;
	public InvGarantiaDAO(){
		super();
	}


	/* Alta de Inversion en Garantia */
	public MensajeTransaccionBean alta(final InvGarantiaBean invGarantiaBean,final int tipoTransaccion) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		final PolizaBean polizaBean=new PolizaBean();

		polizaBean.setConceptoID(InvGarantiaBean.inversionGarantia);
		polizaBean.setConcepto(InvGarantiaBean.desInversionGarantia);

		int	contador  = 0;
		while(contador <= PolizaBean.numIntentosGeneraPoliza){
			contador ++;
			polizaDAO.generaPolizaIDGenerico(polizaBean,parametrosAuditoriaBean.getNumeroTransaccion());
			if (Utileria.convierteEntero(polizaBean.getPolizaID()) > 0){
				break;
			}
		}
		if (Utileria.convierteEntero(polizaBean.getPolizaID()) >0){
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				 String poliza =polizaBean.getPolizaID();
				try {
					invGarantiaBean.setPolizaID(poliza);
					mensajeBean=alta(invGarantiaBean,parametrosAuditoriaBean.getNumeroTransaccion());
					if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					if(mensajeBean.getNumero()==0){
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta de inversion en garantia", e);
				}
				return mensajeBean;
			}
		});
		/* Baja de Poliza en caso de que haya ocurrido un error */
		if (mensaje.getNumero() != 0) {
			try {
				PolizaBean bajaPolizaBean = new PolizaBean();
				bajaPolizaBean.setTipo(PolizaDAO.Enum_TipoBajaPoliza.bajaPolizaId);
				bajaPolizaBean.setNumTransaccion(String.valueOf(Constantes.ENTERO_CERO));
				bajaPolizaBean.setNumErrPol(mensaje.getNumero() + "");
				bajaPolizaBean.setErrMenPol(mensaje.getDescripcion());
				bajaPolizaBean.setDescProceso("InvGarantiaDao.alta");
				bajaPolizaBean.setPolizaID(invGarantiaBean.getPolizaID());
				MensajeTransaccionBean mensajeBaja = new MensajeTransaccionBean();
				mensajeBaja = polizaDAO.bajaPoliza(bajaPolizaBean);
				loggerSAFI.error("InvGarantiaDao.alta: Credito: " + invGarantiaBean.getCreditoID() + " Numero Error:" + mensajeBaja.getNumero() + " Mensaje: " + mensajeBaja.getDescripcion());
			} catch (Exception ex) {
				ex.printStackTrace();
			}
		}
	}else{
		mensaje.setNumero(999);
		mensaje.setDescripcion("El Número de Póliza se encuentra Vacio");
		mensaje.setNombreControl("numeroTransaccion");
		mensaje.setConsecutivoString("0");
	}
	return mensaje;
}
	public MensajeTransaccionBean alta(final InvGarantiaBean invGarantiaBean,final long numTransaccion) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "call CREDITOINVGARALT(" +
										"?,?,?,?,?, ?,?,?,?,?," +
										"?,?,?,?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);

								sentenciaStore.setLong("Par_CreditoID",Utileria.convierteLong(invGarantiaBean.getCreditoID()));
								sentenciaStore.setInt("Par_InversionID",Utileria.convierteEntero(invGarantiaBean.getInversionID()));
								sentenciaStore.setInt("Par_PolizaID", Utileria.convierteEntero(invGarantiaBean.getPolizaID()));
								sentenciaStore.setDouble("Par_MontoEnGar",Utileria.convierteDoble(invGarantiaBean.getMontoEnGar()));
								sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);

								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
								sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
								sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
								sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
								sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());

								sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
								sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
								sentenciaStore.setLong("Aud_NumTransaccion",numTransaccion);
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
									mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.");
								}
								return mensajeTransaccion;
							}
						}
						);

					if(mensajeBean ==  null){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						mensajeBean.setDescripcion("El bean es igual a null");
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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta de InvGarantia", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	// actualizar  creditoinv
	public MensajeTransaccionBean actualizar(final InvGarantiaBean invGarantiaBean,final int tipoActualizacion) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "call CREDITOINVGARACT(" +
										"?,?,?,?,?, ?,?,?,?,?," +
										"?,?,?,?,?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);
								sentenciaStore.setLong("Par_CreditoInvGarID",Utileria.convierteLong(invGarantiaBean.getCreditoInvGarID()));
								sentenciaStore.setLong("Par_CreditoID",Utileria.convierteLong(invGarantiaBean.getCreditoID()));
								sentenciaStore.setInt("Par_InversionID",Utileria.convierteEntero(invGarantiaBean.getInversionID()));
								sentenciaStore.setLong("Par_PolizaID",Utileria.convierteLong(invGarantiaBean.getPolizaID()));
								sentenciaStore.setInt("Par_NumAct",tipoActualizacion);

								sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
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
									mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.");
								}
								return mensajeTransaccion;
							}
						});
					if(mensajeBean ==  null){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						mensajeBean.setDescripcion("El bean es igual a null");
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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en actualizacion de InvGarantia", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	// actualizar  creditoinv  sobrecarga para recibir el numero de transaccion y no generarlos
	public MensajeTransaccionBean actualizar(final InvGarantiaBean invGarantiaBean,final int tipoActualizacion, final long numTransaccion) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "call CREDITOINVGARACT(" +
										"?,?,?,?,?, ?,?,?,?,?," +
										"?,?,?,?,?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);
								sentenciaStore.setLong("Par_CreditoInvGarID",Utileria.convierteLong(invGarantiaBean.getCreditoInvGarID()));
								sentenciaStore.setLong("Par_CreditoID",Utileria.convierteLong(invGarantiaBean.getCreditoID()));
								sentenciaStore.setInt("Par_InversionID",Utileria.convierteEntero(invGarantiaBean.getInversionID()));
								sentenciaStore.setLong("Par_PolizaID",Utileria.convierteLong(invGarantiaBean.getPolizaID()));
								sentenciaStore.setInt("Par_NumAct",tipoActualizacion);
								sentenciaStore.setString("Par_Salida",Constantes.salidaSI);

								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
								sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
								sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
								sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());

								sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
								sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
								sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
								sentenciaStore.setLong("Aud_NumTransaccion",numTransaccion);
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
									mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.");
								}
								return mensajeTransaccion;
							}
						});
					if(mensajeBean ==  null){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						mensajeBean.setDescripcion("El bean es igual a null");
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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en actualizacion de InvGarantia", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	/* Metodo para liberar inversiones en garantia */
	public MensajeTransaccionBean liberar(final InvGarantiaBean invGarantiaBean,final int tipoActualizacion, final ArrayList listaMovimientos) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
				new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
		MensajeTransaccionBean resultadoBean = new MensajeTransaccionBean();
		InvGarantiaBean invGarantia =null;
		final PolizaBean polizaBean=new PolizaBean();

		polizaBean.setConceptoID(InvGarantiaBean.inversionGarantia);
		polizaBean.setConcepto(InvGarantiaBean.desLiberacionGarantia);

		int	contador  = 0;
		while(contador <= PolizaBean.numIntentosGeneraPoliza){
			contador ++;
			polizaDAO.generaPolizaIDGenerico(polizaBean,parametrosAuditoriaBean.getNumeroTransaccion());
			if (Utileria.convierteEntero(polizaBean.getPolizaID()) > 0){
				break;
			}
		}
		String poliza =polizaBean.getPolizaID();
			try{
				if(!listaMovimientos.isEmpty() && listaMovimientos != null){
					for(int i=0; i < listaMovimientos.size(); i++){
						invGarantia = (InvGarantiaBean)listaMovimientos.get(i);
						if(!invGarantia.getCreditoInvGarID().isEmpty()){
							if (Utileria.convierteEntero(polizaBean.getPolizaID()) >0){
								invGarantia.setPolizaID(poliza);
								resultadoBean = actualizar(invGarantia, tipoActualizacion,parametrosAuditoriaBean.getNumeroTransaccion());
								if(resultadoBean.getNumero()!=0){
									throw new Exception(resultadoBean.getDescripcion());
								}
						   }
							else{
								resultadoBean.setNumero(999);
								resultadoBean.setDescripcion("El Número de Póliza se encuentra Vacio");
								resultadoBean.setNombreControl("numeroTransaccion");
								resultadoBean.setConsecutivoString("0");
							}
						}}
				}else{
					resultadoBean.setNumero(999);
					resultadoBean.setDescripcion("Debe seleccionar al menos un elemento para poder liberarlo.");
					resultadoBean.setNombreControl(Constantes.STRING_VACIO);
					resultadoBean.setConsecutivoString(Constantes.STRING_CERO);
					throw new Exception("Debe seleccionar al menos un elemento para poder liberarlo.");
				}
			}catch(Exception e){
				if (resultadoBean.getNumero() == 0) {
					resultadoBean.setNumero(999);
					resultadoBean.setDescripcion(e.getMessage());
					resultadoBean.setNombreControl(resultadoBean.getNombreControl());
					resultadoBean.setConsecutivoString(Constantes.STRING_CERO);
				}
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en liberacion de inversion en garantia", e);
			transaction.setRollbackOnly();
		}
		return resultadoBean;
	   }
	});
	return mensaje;
	}


	/* Consulta el total Garantizado de CReditos solo por el concepto de inversiones*/
	public InvGarantiaBean consultaTotalGarantizadoCreditoInversiones(InvGarantiaBean invGarantiaBean, int tipoConsulta){
		String query = "call CREDITOINVGARCON(" +
				"?,?,?,?,?,	?,?,?,?,?);";
		Object[] parametros = {
				Utileria.convierteLong(invGarantiaBean.getCreditoID()),
				Utileria.convierteLong(invGarantiaBean.getInversionID()),
				tipoConsulta,
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,

				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"InversionDAO.consulta",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
		};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CREDITOINVGARCON(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				InvGarantiaBean invGarantiaBeanB = new InvGarantiaBean();
				invGarantiaBeanB.setTotalGarCredInv(resultSet.getString("TotalCred"));
				return invGarantiaBeanB;
			}
		});
		return matches.size() > 0 ? (InvGarantiaBean) matches.get(0) : null;
	}

	/* Consulta el total Garantizado por una inversion*/
	public InvGarantiaBean consultaTotalGarantizadoInversion(InvGarantiaBean invGarantiaBean, int tipoConsulta){
		String query = "call CREDITOINVGARCON(" +
				"?,?,?,?,?,	?,?,?,?,?);";
		Object[] parametros = {
				Utileria.convierteLong(invGarantiaBean.getCreditoID()),
				Utileria.convierteLong(invGarantiaBean.getInversionID()),
				tipoConsulta,
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,

				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"InversionDAO.consulta",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
		};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CREDITOINVGARCON(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				InvGarantiaBean invGarantiaBeanB = new InvGarantiaBean();
				invGarantiaBeanB.setTotalGarInv(resultSet.getString("TotalInv"));
				return invGarantiaBeanB;
			}
		});
		return matches.size() > 0 ? (InvGarantiaBean) matches.get(0) : null;
	}

	public InvGarantiaBean consultagarliqCubierta(final InvGarantiaBean invGarantiaBean) {
		InvGarantiaBean mensaje = new InvGarantiaBean();
		mensaje = (InvGarantiaBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
				new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				InvGarantiaBean mensajeBean = new InvGarantiaBean();
				try {
					// Query con el Store Procedure
			mensajeBean = (InvGarantiaBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "call CREGARLIQCON(" +
										"?,?,?,?,?, ?,?,?,?,?," +
										"?,?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);

								sentenciaStore.setLong("Par_CreditoID",Utileria.convierteLong(invGarantiaBean.getCreditoID()));
								sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
								sentenciaStore.registerOutParameter("montoGarLiq",Types.DECIMAL);
								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

								sentenciaStore.setInt("Par_EmpresaID",Constantes.ENTERO_CERO);
								sentenciaStore.setInt("Aud_Usuario", Constantes.ENTERO_CERO);
								sentenciaStore.setDate("Aud_FechaActual", java.sql.Date.valueOf("1900-01-01"));
								sentenciaStore.setString("Aud_DireccionIP",Constantes.STRING_VACIO);
								sentenciaStore.setString("Aud_ProgramaID","CreditosDAO");

								sentenciaStore.setInt("Aud_Sucursal",Constantes.ENTERO_CERO);
								sentenciaStore.setLong("Aud_NumTransaccion",Constantes.ENTERO_CERO);
							    loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());
							    return sentenciaStore;
							}
						},new CallableStatementCallback() {
							public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,
																											DataAccessException {
								InvGarantiaBean mensajeTransaccion = new InvGarantiaBean();
								if(callableStatement.execute()){
									ResultSet resultadosStore = callableStatement.getResultSet();

									resultadosStore.next();
									mensajeTransaccion.setMontoGarLiq(String.valueOf(resultadosStore.getDouble(1)));
								}
								return mensajeTransaccion;
							}
						}
						);

				} catch (Exception e) {

					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en CREGARLIQCON fallo", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}


	// lista las inversiones que esten respaldando a algun credito
	public InvGarantiaBean consultaCredito(InvGarantiaBean invGarantiaBean, int tipoConsulta){
		String query = "call CREDITOINVGARCON(" +
				"?,?,?,?,?,	?,?,?,?,?);";
		Object[] parametros = {
				Utileria.convierteLong(invGarantiaBean.getCreditoID()),
				Utileria.convierteLong(invGarantiaBean.getInversionID()),
				tipoConsulta,
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,

				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"InversionDAO.consulta",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
		};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CREDITOINVGARCON(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				InvGarantiaBean invGarantiaBeanB = new InvGarantiaBean();
				invGarantiaBeanB.setCreditoInvGarID(resultSet.getString("CreditoInvGarID"));
				return invGarantiaBeanB;
			}
		});
		return matches.size() > 0 ? (InvGarantiaBean) matches.get(0) : null;
	}

	// consulta las inversion
	public InvGarantiaBean consultaInversion(InvGarantiaBean invGarantiaBean, int tipoConsulta){
		String query = "call CREDITOINVGARCON(" +
				"?,?,?,?,?,	?,?,?,?,?);";
		Object[] parametros = {
				Utileria.convierteLong(invGarantiaBean.getCreditoID()),
				Utileria.convierteLong(invGarantiaBean.getInversionID()),
				tipoConsulta,
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,

				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"InversionDAO.consulta",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
		};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CREDITOINVGARCON(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				InvGarantiaBean invGarantiaBeanB = new InvGarantiaBean();
				invGarantiaBeanB.setCreditoInvGarID(resultSet.getString("CreditoInvGarID"));
				invGarantiaBeanB.setCreditosRelacionados(resultSet.getString("CreditosRelacionados"));
				return invGarantiaBeanB;
			}
		});
		return matches.size() > 0 ? (InvGarantiaBean) matches.get(0) : null;
	}

	// consulta si el credito tiene el estatus parametrizado
	public InvGarantiaBean consultaCreditoEstatus(InvGarantiaBean invGarantiaBean, int tipoConsulta){
		String query = "call CREDITOINVGARCON(" +
				"?,?,?,?,?,	?,?,?,?,?);";
		Object[] parametros = {
				Utileria.convierteLong(invGarantiaBean.getCreditoID()),
				Utileria.convierteLong(invGarantiaBean.getInversionID()),
				tipoConsulta,
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,

				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"InversionDAO.consulta",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
		};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CREDITOINVGARCON(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				InvGarantiaBean invGarantiaBeanB = new InvGarantiaBean();
				invGarantiaBeanB.setCreditoID(resultSet.getString("CreditoID"));
				invGarantiaBeanB.setEstatus(resultSet.getString("Estatus"));
				invGarantiaBeanB.setEstCreAltInvGar(resultSet.getString("EstCreAltInvGar"));
				return invGarantiaBeanB;
			}
		});
		return matches.size() > 0 ? (InvGarantiaBean) matches.get(0) : null;
	}

	//Lista para Principal por Cliente y Estatus
	public List listaPrincipal(InvGarantiaBean invGarantiaBean, int tipoLista){
		String query = "call CREDITOINVGARLIS(" +
				"?,?,?,?,?,	?,?,?,?,?," +
				"?,?);";
		Object[] parametros = {
				invGarantiaBean.getCreditoID(),
				invGarantiaBean.getClienteID(),
				invGarantiaBean.getInversionID(),
				invGarantiaBean.getNombreCliente(),
				tipoLista,

				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				"InvGarantiaDAO.listaPrincipal",

				parametrosAuditoriaBean.getSucursal(),
				parametrosAuditoriaBean.getNumeroTransaccion()
		};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CREDITOINVGARLIS(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				InvGarantiaBean invGarantiaBeanB = new InvGarantiaBean();
				invGarantiaBeanB.setInversionID(resultSet.getString("InversionID"));
				invGarantiaBeanB.setEtiqueta(resultSet.getString("Etiqueta"));
				invGarantiaBeanB.setMontoInversion(resultSet.getString("Monto"));
				invGarantiaBeanB.setFechaVencimiento(resultSet.getString("FechaVencimiento"));
				return invGarantiaBeanB;
			}
		});
		return matches;
	}

	//Lista para Principal por Cliente y Estatus
	public List listaInverAsignadas(InvGarantiaBean invGarantiaBean, int tipoLista){
		String query = "call CREDITOINVGARLIS(" +
				"?,?,?,?,?,	?,?,?,?,?," +
				"?,?);";
		Object[] parametros = {
				invGarantiaBean.getCreditoID(),
				invGarantiaBean.getClienteID(),
				invGarantiaBean.getInversionID(),
				invGarantiaBean.getNombreCliente(),
				tipoLista,

				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				"InvGarantiaDAO.listaPrincipal",

				parametrosAuditoriaBean.getSucursal(),
				parametrosAuditoriaBean.getNumeroTransaccion()
		};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CREDITOINVGARLIS(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				InvGarantiaBean invGarantiaBeanB = new InvGarantiaBean();
				invGarantiaBeanB.setCreditoInvGarID(resultSet.getString("CreditoInvGarID"));
				invGarantiaBeanB.setInversionID(resultSet.getString("InversionID"));
				invGarantiaBeanB.setEtiqueta(resultSet.getString("Etiqueta"));
				invGarantiaBeanB.setMontoInversion(resultSet.getString("Monto"));
				invGarantiaBeanB.setMontoEnGar(resultSet.getString("MontoEnGar"));
				invGarantiaBeanB.setFechaVencimiento(resultSet.getString("FechaVencimiento"));
				return invGarantiaBeanB;
			}
		});
		return matches;
	}

	// lista los creditos asignados a una inversion se ocupa en la liberacion
	public List listaCreditosAsignados(InvGarantiaBean invGarantiaBean, int tipoLista){
		String query = "call CREDITOINVGARLIS(" +
				"?,?,?,?,?,	?,?,?,?,?," +
				"?,?);";
		Object[] parametros = {
				invGarantiaBean.getCreditoID(),
				invGarantiaBean.getClienteID(),
				invGarantiaBean.getInversionID(),
				invGarantiaBean.getNombreCliente(),
				tipoLista,

				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				"InvGarantiaDAO.listaPrincipal",

				parametrosAuditoriaBean.getSucursal(),
				parametrosAuditoriaBean.getNumeroTransaccion()
		};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CREDITOINVGARLIS(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				InvGarantiaBean invGarantiaBeanB = new InvGarantiaBean();
				invGarantiaBeanB.setCreditoID(resultSet.getString("CreditoID"));
				invGarantiaBeanB.setMontoCredito(resultSet.getString("MontoCredito"));
				invGarantiaBeanB.setFechaVencimiento(resultSet.getString("FechaVencimien"));
				invGarantiaBeanB.setMontoEnGar(resultSet.getString("MontoEnGar"));
				invGarantiaBeanB.setDiasAtraso(resultSet.getString("diasAtraso"));

				invGarantiaBeanB.setCreditoInvGarID(resultSet.getString("CreditoInvGarID"));
				invGarantiaBeanB.setPorcGarLiq(resultSet.getString("PorcGarLiq"));
				invGarantiaBeanB.setEstatus(resultSet.getString("Estatus"));
				invGarantiaBeanB.setEstatusDes(resultSet.getString("EstatusDes"));
				return invGarantiaBeanB;
			}
		});
		return matches;
	}

	// lista las inversiones asignadas a un credito se ocupa en la liberacion
	public List listaCreAutVigVenGar(InvGarantiaBean invGarantiaBean, int tipoLista){
		List listaCreditos = null;
		try{
			String query = "call CREDITOINVGARLIS(" +
					"?,?,?,?,?,	?,?,?,?,?," +
					"?,?);";
			Object[] parametros = {
					invGarantiaBean.getCreditoID(),
					invGarantiaBean.getClienteID(),
					invGarantiaBean.getInversionID(),
					invGarantiaBean.getNombreCliente(),
					tipoLista,

					parametrosAuditoriaBean.getEmpresaID(),
					parametrosAuditoriaBean.getUsuario(),
					parametrosAuditoriaBean.getFecha(),
					parametrosAuditoriaBean.getDireccionIP(),
					"InvGarantiaDAO.listaPrincipal",

					parametrosAuditoriaBean.getSucursal(),
					parametrosAuditoriaBean.getNumeroTransaccion()
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CREDITOINVGARLIS(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					InvGarantiaBean invGarantiaBeanB = new InvGarantiaBean();
					invGarantiaBeanB.setCreditoID(resultSet.getString("CreditoID"));
					invGarantiaBeanB.setNombreCliente(resultSet.getString("NombreCompleto"));
					invGarantiaBeanB.setEstatus(resultSet.getString("Estatus"));
					invGarantiaBeanB.setEstatusDes(resultSet.getString("EstatusDes"));
					invGarantiaBeanB.setFechaInicio(resultSet.getString("FechaInicio"));
					invGarantiaBeanB.setFechaVencimiento(resultSet.getString("FechaVencimien"));

					invGarantiaBeanB.setProductoCreditoDes(resultSet.getString("Descripcion"));
					return invGarantiaBeanB;
				}
			});
			listaCreditos = matches;
		}catch(Exception e){
			e.printStackTrace();
		}
		return listaCreditos;

	}


	//Lista para Principal por Cliente y Estatus
	public List listaInversionesEnGarantia(InvGarantiaBean invGarantiaBean, int tipoLista){
		String query = "call CREDITOINVGARLIS(" +
				"?,?,?,?,?,	?,?,?,?,?," +
				"?,?);";
		Object[] parametros = {
				invGarantiaBean.getCreditoID(),
				invGarantiaBean.getClienteID(),
				invGarantiaBean.getInversionID(),
				invGarantiaBean.getNombreCliente(),
				tipoLista,

				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				"InvGarantiaDAO.listaPrincipal",

				parametrosAuditoriaBean.getSucursal(),
				parametrosAuditoriaBean.getNumeroTransaccion()
		};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CREDITOINVGARLIS(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				InvGarantiaBean invGarantiaBeanB = new InvGarantiaBean();
				invGarantiaBeanB.setInversionID(resultSet.getString("InversionID"));
				invGarantiaBeanB.setNombreCliente(resultSet.getString("NombreCompleto"));
				invGarantiaBeanB.setEtiqueta(resultSet.getString("Etiqueta"));
				invGarantiaBeanB.setMontoInversion(resultSet.getString("Monto"));
				return invGarantiaBeanB;
			}
		});
		return matches;
	}

	public PolizaDAO getPolizaDAO() {
		return polizaDAO;
	}

	public void setPolizaDAO(PolizaDAO polizaDAO) {
		this.polizaDAO = polizaDAO;
	}
}
