package tesoreria.dao;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;

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

import psl.rest.MetodoHTTP;

import java.sql.ResultSetMetaData;

import contabilidad.bean.PolizaBean;
import contabilidad.dao.PolizaDAO;
import credito.bean.ReporteMinistraBean;
import tesoreria.bean.BloqueoBean;
import tesoreria.bean.CuentasAhoTesoBean;
import tesoreria.bean.DispersionBean;
import tesoreria.bean.DispersionGridBean;
import tesoreria.bean.ProteccionOrdenPagoBean;
import tesoreria.bean.RenovacionOrdenPagoBean;
import tesoreria.servicio.OperDispersionServicio.Enum_Act_Dispersion;
import tesoreria.bean.ReporteDispersionBean;
import ventanilla.bean.ChequesEmitidosBean;
import ventanilla.dao.ChequesEmitidosDAO;
import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;

public class OperDispersionDAO extends BaseDAO {
	PolizaDAO polizaDAO = new PolizaDAO();
	ChequesEmitidosDAO chequesEmitidosDAO = null;
	RenovacionOrdenPagoDAO renovacionOrdenPagoDAO = null;
	public String conceptoDispersionRecursos="82"; //tabla CONCEPTOSCONTA
	public String conceptoDispersionRecursosDes="DISPERSION DE RECURSOS"; //tabla CONCEPTOSCONTA
	String automatico = "A"; // indica que se trata de una poliza automatica

	public OperDispersionDAO(){
		super();
	}

	public static interface Enum_Tipo_Naturaleza {
		String bloqueado = "B";
		String desbloqueado = "D";
	}

	public static interface Enum_Tipo_Bloqueo {
		String dispersion = "1";
	}

	public static interface Enum_Pantalla {
		String imprime = "S";
	}

	public static interface Enum_Institucion {
		int institucion = 24;
	}

	private final static String salidaPantalla = "S";

	/*Guarda el encabezado de la Dispersion */
	/*  Alta de la dispersion */
	public MensajeTransaccionBean altaEncabezado(final DispersionBean dispersionBean, final long numeroTransaccion){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call DISPERSIONALT(?,?,?,?,?, ?, ?,?,?,?,?, ?,?,?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);

									sentenciaStore.setString("Par_FechaOperacion", dispersionBean.getFechaOperacion());
									sentenciaStore.setInt("Par_Institucion", Utileria.convierteEntero(dispersionBean.getInstitucionID()));
									sentenciaStore.setLong("Par_CuentaAho", Utileria.convierteLong(dispersionBean.getNumCtaInstit()));
									sentenciaStore.setString("Par_NumCtaInstit", dispersionBean.getNumCtaInstit());
									sentenciaStore.setString("Par_Salida",salidaPantalla);

									//Parametros de OutPut
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
									sentenciaStore.registerOutParameter("Var_FolioSalida", Types.INTEGER);

									//Parametros de Auditoria
									sentenciaStore.setInt("Aud_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
									sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
									sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
									sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
									sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
									sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
									loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());
									if(numeroTransaccion==0){
										transaccionDAO.generaNumeroTransaccion();
										sentenciaStore.setLong("Aud_NumTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());
									}else{
										sentenciaStore.setLong("Aud_NumTransaccion",numeroTransaccion);
									}

									return sentenciaStore;
								}
							},new CallableStatementCallback() {
								public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException, DataAccessException {
									MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
									if(callableStatement.execute()){
										ResultSet resultadosStore = callableStatement.getResultSet();

										resultadosStore.next();
										mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
										mensajeTransaccion.setDescripcion(resultadosStore.getString(2));
										mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
										mensajeTransaccion.setConsecutivoString(resultadosStore.getString(4));
										mensajeTransaccion.setConsecutivoInt(resultadosStore.getString(4));

									}else{
										mensajeTransaccion.setNumero(999);
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .OperDispersionDAO.altaBitacoraCobAuto");
									}
									return mensajeTransaccion;
								}
							});

						if(mensajeBean ==  null){
							mensajeBean = new MensajeTransaccionBean();
							mensajeBean.setNumero(999);
							throw new Exception(Constantes.MSG_ERROR + " .OperDispersionDAO.altaBitacoraCobAuto");

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
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta de encabezado", e);
					}
					return mensajeBean;
				}
			});
			return mensaje;
	}


	int valorError = 0;

	/* Guarda el cuerpo de la dispersion  */
	public MensajeTransaccionBean altaCuerpoDetalle(final DispersionGridBean dispersionGridBean, final int folioOperacion,
			final long numeroTransaccion){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();

		//transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call DISPERSIONMOVALT(" +
											"?,?,?,?,?, ?,?,?,?,?," +
											"?,?,?,?,?, ?,?,?,?,?," +
											"?,?,?,?,?, ?,?,?,?,?," +
											"?,?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);

									sentenciaStore.setInt("Par_FolioOperacion", folioOperacion);
									sentenciaStore.setLong("Par_CuentaAhoID", Utileria.convierteLong(dispersionGridBean.getGridCuentaAhoID()));
									sentenciaStore.setString("Par_CuentaContable",  dispersionGridBean.getCuentaContable());
									sentenciaStore.setString("Par_Descripcion",dispersionGridBean.getGridDescripcion());
									sentenciaStore.setString("Par_Referencia",dispersionGridBean.getGridReferencia());

									sentenciaStore.setInt("Par_TipoMov",Utileria.convierteEntero(dispersionGridBean.getGridTipoMov()));
								    sentenciaStore.setInt("Par_FormaPago",Utileria.convierteEntero(dispersionGridBean.getGridFormaPago()));
								    sentenciaStore.setDouble("Par_Monto", Utileria.convierteDoble(dispersionGridBean.getGridMonto()));
								    sentenciaStore.setString("Par_CuentaClabe",dispersionGridBean.getGridCuentaClabe());
								    sentenciaStore.setString("Par_NombreBenefi",dispersionGridBean.getGridNombreBenefi());

								    sentenciaStore.setString("Par_FechaEnvio",dispersionGridBean.getGridFechaEnvio());
								    sentenciaStore.setString("Par_RFC",dispersionGridBean.getGridRFC());
								    sentenciaStore.setString("Par_Status",dispersionGridBean.getGridEnviados());
								    sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
								    sentenciaStore.setInt("Par_SucursalID",parametrosAuditoriaBean.getSucursal());

								    sentenciaStore.setInt("Par_CreditoID",Constantes.ENTERO_CERO);
								    sentenciaStore.setInt("Par_ProveedorID",Constantes.ENTERO_CERO);
								    sentenciaStore.setInt("Par_FacturaProvID",Constantes.ENTERO_CERO);
								    sentenciaStore.setInt("Par_DetReqGasID",Constantes.ENTERO_CERO);
								    sentenciaStore.setInt("Par_TipoGastoID",Constantes.ENTERO_CERO);

								    sentenciaStore.setInt("Par_CatalogoServID",Constantes.ENTERO_CERO);
								    sentenciaStore.setString("Par_AnticipoFact",dispersionGridBean.getGridAnticipoPago());
								    sentenciaStore.setString("Par_TipoChequera",dispersionGridBean.getGridTipoChequera());
								    //Parametros de OutPut
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
									sentenciaStore.registerOutParameter("Par_RegistroSalida", Types.INTEGER);
									//Parametros de Auditoria
									sentenciaStore.setInt("Aud_EmpresaID", parametrosAuditoriaBean.getEmpresaID());

									sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
									sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
									sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
									sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
									sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());

									sentenciaStore.setLong("Aud_NumTransaccion", numeroTransaccion);

									loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());

									return sentenciaStore;
								}
							},new CallableStatementCallback() {
								public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException, DataAccessException {
									MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
									MensajeTransaccionBean mensajeBloqueo = null;

									if(callableStatement.execute()){
										ResultSet resultadosStore = callableStatement.getResultSet();

										resultadosStore.next();

										mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString("NumErr")).intValue());
										mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
										mensajeTransaccion.setNombreControl(resultadosStore.getString("control"));
										mensajeTransaccion.setConsecutivoInt(resultadosStore.getString("consecutivo"));


									}else{
										mensajeTransaccion.setNumero(999);
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .OperDispersionDAO.altaBitacoraCobAuto-1");
									}
									return mensajeTransaccion;
								}
							});

						if(mensajeBean ==  null){
							mensajeBean = new MensajeTransaccionBean();
							mensajeBean.setNumero(999);
							throw new Exception(Constantes.MSG_ERROR + " .OperDispersionDAO.altaBitacoraCobAuto-2");

						}else if(mensajeBean.getNumero()!=0){
							throw new Exception(mensajeBean.getDescripcion());
						}
					} catch (Exception e) {
						e.printStackTrace();
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta de cuerpo de detalle", e);
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


	/* Guarda el cuerpo de la dispersion  */
	public MensajeTransaccionBean actualizaCuerpoDetalle(final DispersionGridBean dispersionGridBean, final int tipoActualizacion,
			final long numeroTransaccion){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();

		//transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call DISPERSIONMOVACT(" +
											"?,?,?,?,?, ?,?,?,?,?," +
											"?,?,?,?,?, ?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);

									sentenciaStore.setInt("Par_ClaveDispMov", Utileria.convierteEntero(dispersionGridBean.getClaveDispersion()));
									sentenciaStore.setInt("Par_DispersionID", Utileria.convierteEntero(dispersionGridBean.getFolioOperacion()));

									sentenciaStore.setString("Par_Estatus",  dispersionGridBean.getGridEnviados());
									sentenciaStore.setString("Par_CuentaCheque",dispersionGridBean.getGridCuentaClabe());
									sentenciaStore.setInt("Par_TipoAct",tipoActualizacion);

									sentenciaStore.setInt("Par_TipoConcepto",Utileria.convierteEntero(dispersionGridBean.getGridTipoConcepto()));

								    sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
								    //Parametros de OutPut
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
									sentenciaStore.registerOutParameter("Par_Consecutivo", Types.INTEGER);
									//Parametros de Auditoria
									sentenciaStore.setInt("Par_EmpresaID", parametrosAuditoriaBean.getEmpresaID());

									sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
									sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
									sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
									sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
									sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());

									sentenciaStore.setLong("Aud_NumTransaccion", numeroTransaccion);

									loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());

									return sentenciaStore;
								}
							},new CallableStatementCallback() {
								public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException, DataAccessException {
									MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
									MensajeTransaccionBean mensajeBloqueo = null;

									if(callableStatement.execute()){
										ResultSet resultadosStore = callableStatement.getResultSet();

										resultadosStore.next();

										mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString("NumErr")).intValue());
										mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
										mensajeTransaccion.setNombreControl(resultadosStore.getString("control"));
										mensajeTransaccion.setConsecutivoInt(resultadosStore.getString("consecutivo"));


									}else{
										mensajeTransaccion.setNumero(999);
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .OperDispersionDAO.actualizaCuerpoDetalle-1");
									}
									return mensajeTransaccion;
								}
							});

						if(mensajeBean ==  null){
							mensajeBean = new MensajeTransaccionBean();
							mensajeBean.setNumero(999);
							throw new Exception(Constantes.MSG_ERROR + " .OperDispersionDAO.actualizaCuerpoDetalle-2");

						}else if(mensajeBean.getNumero()!=0){
							throw new Exception(mensajeBean.getDescripcion());
						}
					} catch (Exception e) {
						e.printStackTrace();
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en actualizar de cuerpo de detalle", e);
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


	/*  Alta de la referencia de orden de pago */
	public MensajeTransaccionBean altaRefOrdenPagoSan(final DispersionGridBean dispersionGridBean,final DispersionBean dispersionBean ,final int folioOperacion ,final long numeroTransaccion){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call REFORDENPAGOSANALT(?,?,?,?,?, ?, ?,?,?,?,?, ?,?,?,?,?,?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);

									sentenciaStore.setString("Par_Referencia", dispersionGridBean.getGridCuentaClabe());
									sentenciaStore.setInt("Par_Complemento", Utileria.convierteEntero(dispersionBean.getComplemento()));
									sentenciaStore.setLong("Par_FolioOperacion", folioOperacion);
									sentenciaStore.setString("Par_ClaveDispMov", dispersionBean.getClaveDisp());
									sentenciaStore.setString("Par_FechaRegistro", dispersionGridBean.getGridFechaEnvio());
									sentenciaStore.setString("Par_FechaVencimiento", dispersionBean.getFechaVen());
									sentenciaStore.setString("Par_Tipo", dispersionBean.getTipoRef());
									sentenciaStore.setString("Par_Folio",dispersionGridBean.getGridCuentaAhoID());

									sentenciaStore.setString("Par_Salida",salidaPantalla);

									//Parametros de OutPut
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);


									//Parametros de Auditoria
									sentenciaStore.setInt("Par_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
									sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
									sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
									sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
									sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
									sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
									loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());
									if(numeroTransaccion==0){
										transaccionDAO.generaNumeroTransaccion();
										sentenciaStore.setLong("Aud_NumTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());
									}else{
										sentenciaStore.setLong("Aud_NumTransaccion",numeroTransaccion);
									}

									return sentenciaStore;
								}
							},new CallableStatementCallback() {
								public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException, DataAccessException {
									MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
									if(callableStatement.execute()){
										ResultSet resultadosStore = callableStatement.getResultSet();

										resultadosStore.next();
										mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
										mensajeTransaccion.setDescripcion(resultadosStore.getString(2));
										mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
										mensajeTransaccion.setConsecutivoString(resultadosStore.getString(4));
										mensajeTransaccion.setConsecutivoInt(resultadosStore.getString(4));

									}else{
										mensajeTransaccion.setNumero(999);
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .OperDispersionDAO.altaBitacoraCobAuto");
									}
									return mensajeTransaccion;
								}
							});

						if(mensajeBean ==  null){
							mensajeBean = new MensajeTransaccionBean();
							mensajeBean.setNumero(999);
							throw new Exception(Constantes.MSG_ERROR + " .OperDispersionDAO.altaBitacoraCobAuto");

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
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta de encabezado", e);
					}
					return mensajeBean;
				}
			});
			return mensaje;
	}





	/* recorrer el gird */
	public List detalleGrid(DispersionBean dispersionBean){

		List<String> claveDispM = dispersionBean.getClaveDispMov();
		List<String> cuentaAho = dispersionBean.getCuentaAhoID();
		List<String> descripcion = dispersionBean.getDescripcion();
		List<String> referencia = dispersionBean.getReferencia();
		List<String> tipoMovimiento = dispersionBean.getTipoMov();
		List<String> formaPago = dispersionBean.getFormaPago();
		List<String> monto = dispersionBean.getMonto();
		List<String> cuentaClabe = dispersionBean.getCuentaClabe();
		List<String> rfc = dispersionBean.getRfc();
		List<String> enviado = dispersionBean.getEstatus();
		List<String> nombreBenefi = dispersionBean.getNombreBenefi();
		List<String> cuentaContabLis = dispersionBean.getCuentaCompletaID();
		List<String> tipoChequerabLis = dispersionBean.getStipoChequera();


		ArrayList listaDetalle = new ArrayList();
		DispersionGridBean dispersionGridBean = null;

		int tamanio = cuentaAho.size();

		for(int i=0; i<tamanio; i++){
			dispersionGridBean = new DispersionGridBean();

			dispersionGridBean.setClaveDispersion(claveDispM.get(i));
			dispersionGridBean.setGridCuentaAhoID(cuentaAho.get(i));
			dispersionGridBean.setGridDescripcion(descripcion.get(i));
			dispersionGridBean.setGridReferencia(referencia.get(i));
			dispersionGridBean.setGridTipoMov(tipoMovimiento.get(i));
			dispersionGridBean.setGridFormaPago(formaPago.get(i));
			dispersionGridBean.setGridMonto(monto.get(i).replace(",", ""));
			dispersionGridBean.setGridCuentaClabe(cuentaClabe.get(i));
			dispersionGridBean.setGridNombreBenefi(nombreBenefi.get(i));
			dispersionGridBean.setGridRFC(rfc.get(i));
			dispersionGridBean.setCuentaContable(cuentaContabLis.get(i));
			dispersionGridBean.setGridTipoChequera(tipoChequerabLis.get(i));
			dispersionGridBean.setGridEnviados((enviado.get(i)!=null || enviado.get(i) !="") ? enviado.get(i) : "P");


			listaDetalle.add(dispersionGridBean);
		}

		return listaDetalle;
	}

	/* metodo para recorrer el grid de autorizacion de dispersion*/
	public List detalleGridAutoriza(DispersionBean dispersionBean){

		List<String> claveDispM = dispersionBean.getClaveDispMovA();
		List<String> cuentaAho = dispersionBean.getCuentaAhoIDA();
		List<String> descripcion = dispersionBean.getDescripcionA();
		List<String> referencia = dispersionBean.getReferenciaA();
		List<String> tipoMovimiento = dispersionBean.getTipoMovA();
		List<String> formaPago = dispersionBean.getFormaPagoA();
		List<String> monto = dispersionBean.getMontoA();
		List<String> cuentaClabe = dispersionBean.getCuentaClabeA();
		List<String> rfc = dispersionBean.getRfcA();
		List<String> enviado = dispersionBean.getEstatusA();
		List<String> nombreBenefi = dispersionBean.getNombreBenefiA();
		List<String> cuentaContabLis = dispersionBean.getCuentaCompletaIDA();
		List<String> clienteLis = dispersionBean.getClienteIDA();
		List<String> tipoChequerabLis = dispersionBean.getStipoChequera();


		ArrayList listaDetalle = new ArrayList();
		DispersionGridBean dispersionGridBean = null;

		int tamanio = cuentaAho.size();


		for(int i=0; i<tamanio; i++){
			dispersionGridBean = new DispersionGridBean();

			dispersionGridBean.setClaveDispersion(claveDispM.get(i));
			dispersionGridBean.setGridCuentaAhoID(cuentaAho.get(i));
			dispersionGridBean.setGridDescripcion(descripcion.get(i));
			dispersionGridBean.setGridReferencia(referencia.get(i));
			dispersionGridBean.setGridTipoMov(tipoMovimiento.get(i));
			dispersionGridBean.setGridFormaPago(formaPago.get(i));
			dispersionGridBean.setGridMonto(monto.get(i).replace(",", ""));
			dispersionGridBean.setGridCuentaClabe(cuentaClabe.get(i));
			dispersionGridBean.setGridNombreBenefi(nombreBenefi.get(i));
			dispersionGridBean.setGridRFC(rfc.get(i));
			dispersionGridBean.setCuentaContable(cuentaContabLis.get(i));
			dispersionGridBean.setClienteID(clienteLis.get(i));
			dispersionGridBean.setGridTipoChequera(tipoChequerabLis.get(i));
			dispersionGridBean.setGridEnviados((enviado.get(i)!=null || enviado.get(i) !="") ? enviado.get(i) : "P");
			listaDetalle.add(dispersionGridBean);
		}

		return listaDetalle;
	}

	public MensajeTransaccionBean altaMovsDispersion(final DispersionBean dispersionBean){
		MensajeTransaccionBean resultado = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		resultado = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
				new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
				ArrayList listaDetalleGrid = null ;
				String mensajeFolio = "0";
				String control="";
				String consecutivo="";
				try{
					// se arma la lista
					listaDetalleGrid = (ArrayList) detalleGrid(dispersionBean);

					//Se crea el Encazado
					mensaje = altaEncabezado(dispersionBean, parametrosAuditoriaBean.getNumeroTransaccion());

					mensajeFolio = mensaje.getDescripcion();
					control = mensaje.getNombreControl();
					consecutivo = mensaje.getConsecutivoInt();

					if(mensaje.getNumero()==0){
						int numDispersionID = Utileria.convierteEntero(mensaje.getConsecutivoInt());
						DispersionGridBean dispersionGridBean = null;
						for(int i=0; i < listaDetalleGrid.size(); i++){
							dispersionGridBean = (DispersionGridBean) listaDetalleGrid.get(i);
							dispersionGridBean.setGridFechaEnvio(dispersionBean.getFechaOperacion());
							mensaje = altaCuerpoDetalle(dispersionGridBean, numDispersionID, parametrosAuditoriaBean.getNumeroTransaccion());
								if(mensaje.getNumero() != 0){
										throw new Exception(mensaje.getDescripcion());
								}
							if(mensaje.getNumero() == 0 && !dispersionGridBean.getGridCuentaAhoID().trim().isEmpty()){
								BloqueoBean bloqueoBean = new BloqueoBean();
								String fecha =dispersionGridBean.getGridFechaEnvio();// sdf.format(date);

								bloqueoBean.setNatMovimiento(Enum_Tipo_Naturaleza.bloqueado);
								bloqueoBean.setCuentaAhoID(dispersionGridBean.getGridCuentaAhoID());
								bloqueoBean.setFechaMov(fecha);
								bloqueoBean.setMontoBloq(dispersionGridBean.getGridMonto());
								bloqueoBean.setFechaDesbloq("1900-01-01");
								bloqueoBean.setTiposBloqID(Enum_Tipo_Bloqueo.dispersion);
								bloqueoBean.setDescripcion("BLOQUEO POR DISPERSIÓN");
								bloqueoBean.setReferencia(String.valueOf(parametrosAuditoriaBean.getNumeroTransaccion()));
								String dispmov = mensaje.getConsecutivoInt();
								dispersionBean.setClaveDisp(dispmov);
								mensaje = bloqueaSaldoDao(bloqueoBean, parametrosAuditoriaBean.getNumeroTransaccion());

								if(mensaje.getNumero() != 0){
									valorError = 1;

									throw new Exception(mensaje.getDescripcion());
								}else
								{
									if(dispersionGridBean.getGridFormaPago().equals("5")){
										mensaje = altaRefOrdenPagoSan(dispersionGridBean,dispersionBean,numDispersionID,parametrosAuditoriaBean.getNumeroTransaccion());
										if(mensaje.getNumero() != 0){
										valorError = 1;
										throw new Exception(mensaje.getDescripcion());
										}
									}
									mensaje.setDescripcion(mensajeFolio);
									mensaje.setNombreControl(control);
									mensaje.setConsecutivoInt(consecutivo);
									mensaje.setConsecutivoString(consecutivo);

								}
							}
							else{
								mensaje.setDescripcion(mensajeFolio);
								mensaje.setNombreControl(control);
								mensaje.setConsecutivoInt(consecutivo);
								mensaje.setConsecutivoString(consecutivo);
							}
						}
					}else{
						throw new Exception(mensaje.getDescripcion());
					}


					return mensaje;
				}catch(Exception e){
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta de movimiento de dispersion", e);
					transaction.setRollbackOnly();
				}
				return mensaje;
			}
		});
		return resultado;
	}


	/* Modifica la Dispersion o agrega nuevos elementos que no a sido Autorizada */
	public MensajeTransaccionBean modificarDispersion(final DispersionGridBean dispersionGridBean, final int folioOperacion){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();

		transaccionDAO.generaNumeroTransaccion();

		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {

					MensajeTransaccionBean mensajeBloqueo;

						    mensajeBean = modificaCuerpo(dispersionGridBean, folioOperacion);

						    if(mensajeBean.getNumero()==0){
								BloqueoBean bloqueoBean = new BloqueoBean();

								java.util.Date date = parametrosAuditoriaBean.getFecha();
								java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy-MM-dd");
								String fecha = sdf.format(date);

								bloqueoBean.setNatMovimiento(Enum_Tipo_Naturaleza.bloqueado);
								bloqueoBean.setCuentaAhoID(dispersionGridBean.getGridCuentaAhoID());
								bloqueoBean.setFechaMov(fecha);
								bloqueoBean.setMontoBloq(dispersionGridBean.getGridMonto());
								bloqueoBean.setFechaDesbloq("1900-01-01");
								bloqueoBean.setTiposBloqID(Enum_Tipo_Bloqueo.dispersion);
								bloqueoBean.setDescripcion("Bloqueo por Dispersion");
								bloqueoBean.setReferencia(String.valueOf(parametrosAuditoriaBean.getNumeroTransaccion()));


								mensajeBloqueo = bloqueaSaldoDao(bloqueoBean, parametrosAuditoriaBean.getNumeroTransaccion());

								if(mensajeBloqueo.getNumero()!=0){
									throw new Exception(mensajeBloqueo.getDescripcion());
								}

							}else if(mensajeBean.getNumero()!=0){
								throw new Exception(mensajeBean.getDescripcion());
							}

				}catch (Exception e) {

					if(mensajeBean.getNumero()==0){
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en modifica dispersion", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	public MensajeTransaccionBean actualizaEstatus(final DispersionGridBean dispersionGrid, final DispersionBean dispersionBean, final int numeroPoliza,
			final long numeroTransaccion){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		//transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call DISPERSIONMOVPRO(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);

									sentenciaStore.setInt("Par_ClaveDispMov", Utileria.convierteEntero(dispersionGrid.getClaveDispersion()));
									sentenciaStore.setInt("Par_DispersionID", Utileria.convierteEntero(dispersionBean.getFolioOperacion()));

									sentenciaStore.setString("Par_CuentaCheque",dispersionGrid.getGridCuentaClabe());

									sentenciaStore.setString("Par_Estatus",dispersionGrid.getGridEnviados());
									sentenciaStore.setInt("Par_Poliza",numeroPoliza);
									sentenciaStore.setString("Par_Fecha" ,  dispersionGrid.getGridFechaEnvio());
									sentenciaStore.setString("Par_TipoChequera" ,  dispersionGrid.getGridTipoChequera());
									sentenciaStore.setDouble("Par_Monto" ,  Utileria.convierteDoble(dispersionGrid.getGridMonto()));

								    sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
									//Parametros de OutPut
								    sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
									sentenciaStore.registerOutParameter("Par_Consecutivo", Types.BIGINT);


									//Parametros de Auditoria
									sentenciaStore.setInt("Aud_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
									sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
									sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
									sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
									sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
									sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
									sentenciaStore.setLong("Aud_NumTransaccion", numeroTransaccion);

									// se imprime el call del sp ejecutado en el log
									loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());
									return sentenciaStore;
								}
							},new CallableStatementCallback() {
								public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,
																												DataAccessException {
									MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
									if(callableStatement.execute()){
										ResultSet resultadosStore = callableStatement.getResultSet();
										ResultSetMetaData metaDatos;

										resultadosStore.next();
										mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
										mensajeTransaccion.setDescripcion(resultadosStore.getString(2));
										mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
										metaDatos = (ResultSetMetaData) resultadosStore.getMetaData();
										if(metaDatos.getColumnCount()== 5){
											mensajeTransaccion.setCampoGenerico(resultadosStore.getString(5));// PARA OBTENER EL NUMERO DE LA POLIZA

										}else{

											mensajeTransaccion.setCampoGenerico(Constantes.STRING_CERO);// PARA OBTENER EL NUMERO DE LA POLIZA
										}
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
							throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
						}else if(mensajeBean.getNumero()!=0){
							throw new Exception(mensajeBean.getDescripcion());
						}
					} catch (Exception e) {

						if (mensajeBean.getNumero() == 0) {
							mensajeBean.setNumero(997);
						}
						mensajeBean.setDescripcion(e.getMessage());
						transaction.setRollbackOnly();
						e.printStackTrace();
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en actualizaestatus dispersion", e);
					}
					return mensajeBean;
				}
			});
			return mensaje;

		}

	public MensajeTransaccionBean actualizaEstatusDispersion(final DispersionBean dispersionBean){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
						ArrayList listaDetalleGrid = (ArrayList) detalleGridAutoriza(dispersionBean);

						DispersionGridBean dispersionGridBean = null;

						mensajeBean = actDispersionEnc(dispersionBean, Enum_Act_Dispersion.actCuentas );
						if(mensajeBean.getNumero()==0){

							PolizaBean polizaBean = new PolizaBean();
							int numeroPoliza = 0;
							int tipoCheque = 2;
							int tipoConsulta = 3;
							int tipoCon = 4;

							polizaBean.setConceptoID(conceptoDispersionRecursos);
							polizaBean.setConcepto(conceptoDispersionRecursosDes);
							polizaBean.setTipo(automatico);

							for(int i=0; i<listaDetalleGrid.size(); i++){

								dispersionGridBean = (DispersionGridBean) listaDetalleGrid.get(i);
								polizaBean.setFecha(dispersionBean.getFechaOperacion());//parametrosAuditoriaBean.getFecha().toString());


								if(dispersionGridBean.getGridEnviados().equals("A") &&
										(dispersionGridBean.getGridFormaPago().equals("5") || dispersionGridBean.getGridFormaPago().equals("6"))&&
										dispersionBean.getPermiteVer().equalsIgnoreCase("S")){
									dispersionGridBean.setFolioOperacion(dispersionBean.getFolioOperacion());
									mensajeBean = actualizaCuerpoDetalle(dispersionGridBean,1,parametrosAuditoriaBean.getNumeroTransaccion());
									if(mensajeBean.getNumero() != 0){
										throw new Exception(mensajeBean.getDescripcion());
									}

								}else{
									// si el estatus es activo y aun no se a dado de alta la poliza se agrega una poliza nueva
									if(dispersionGridBean.getGridEnviados().equals("A") && numeroPoliza == 0){
										mensajeBean = polizaDAO.altaPoliza(polizaBean, parametrosAuditoriaBean.getNumeroTransaccion());
										numeroPoliza= Integer.parseInt(mensajeBean.getConsecutivoString());
									}

									dispersionGridBean.setGridFechaEnvio(dispersionBean.getFechaOperacion());
									mensajeBean = actualizaEstatus(dispersionGridBean, dispersionBean,numeroPoliza, parametrosAuditoriaBean.getNumeroTransaccion());
									//tt
									if(mensajeBean.getNumero() != 0){
										throw new Exception(mensajeBean.getDescripcion());
									}

									numeroPoliza = Integer.parseInt(mensajeBean.getCampoGenerico());

									if(dispersionGridBean.getGridEnviados().equals("A") && dispersionGridBean.getGridFormaPago().equals("2")){

										DispersionGridBean dispersionCheque = new DispersionGridBean();

										dispersionGridBean.setFolioOperacion(dispersionBean.getFolioOperacion());
										dispersionCheque = consultaDispersionChequetem(dispersionGridBean,  tipoCon);
										ChequesEmitidosBean chequesEmitidosBean = new ChequesEmitidosBean();
										chequesEmitidosBean.setInstitucionID(dispersionCheque.getInstitucionID());
										chequesEmitidosBean.setCuentaInstitucion(dispersionCheque.getCuentaAhorro());//num cta intitucion
										chequesEmitidosBean.setNumeroCheque(dispersionGridBean.getGridCuentaClabe());//el valor que tre el request
										chequesEmitidosBean.setMonto(dispersionCheque.getGridMonto());
										chequesEmitidosBean.setSucursalID(dispersionCheque.getSucursalID());
										chequesEmitidosBean.setCajaID(null);
										chequesEmitidosBean.setUsuarioID(dispersionCheque.getUsuarioID());
										chequesEmitidosBean.setConcepto(dispersionCheque.getGridDescripcion());
										chequesEmitidosBean.setBeneficiario(dispersionCheque.getGridNombreBenefi());
										chequesEmitidosBean.setReferencia(dispersionCheque.getGridReferencia());
										chequesEmitidosBean.setTipoChequera(dispersionGridBean.getGridTipoChequera());


										mensajeBean = chequesEmitidosDAO.chequesEmitidosAlta(chequesEmitidosBean);
										if(mensajeBean.getNumero() != 0){
											throw new Exception(mensajeBean.getDescripcion());
										}

									}

									//Seccion para dispersión de orden de pago de desembolso de crédito
									if(dispersionGridBean.getGridEnviados().equals("A") && dispersionGridBean.getGridFormaPago().equals("5")){

										DispersionGridBean dispersionOrden= new DispersionGridBean();

										dispersionGridBean.setFolioOperacion(dispersionBean.getFolioOperacion());
										dispersionOrden = consultaDispersionChequetem(dispersionGridBean,  tipoCon);
										RenovacionOrdenPagoBean renovacionOrdenPagoBean = new RenovacionOrdenPagoBean();
										renovacionOrdenPagoBean.setClienteID(dispersionGridBean.getClienteID());
										renovacionOrdenPagoBean.setInstitucionID(dispersionOrden.getInstitucionID());
										renovacionOrdenPagoBean.setNumCtaInstit(dispersionOrden.getCuentaAhorro());
										renovacionOrdenPagoBean.setNumOrdenPago(dispersionGridBean.getGridCuentaClabe());
										renovacionOrdenPagoBean.setMonto(dispersionOrden.getGridMonto());
										renovacionOrdenPagoBean.setConcepto(dispersionOrden.getGridDescripcion());
										renovacionOrdenPagoBean.setBeneficiario(dispersionOrden.getGridNombreBenefi());
										renovacionOrdenPagoBean.setReferencia(dispersionOrden.getGridReferencia());

										mensajeBean = renovacionOrdenPagoDAO.ordenPagoAlta(renovacionOrdenPagoBean);
										if(mensajeBean.getNumero() != 0){
											throw new Exception(mensajeBean.getDescripcion());
										}

									}

								}
									// Si existio algun error en actualizaEstatus(...) atrapa el error
									if(mensajeBean.getNumero() != 0){
										throw new Exception(mensajeBean.getDescripcion());
									}

							}

							mensajeBean = cirreDispersion(dispersionBean, Enum_Act_Dispersion.cierraDisp ,parametrosAuditoriaBean.getNumeroTransaccion());
							mensajeBean.setCampoGenerico(numeroPoliza+"");
						}else{
							throw new Exception(mensajeBean.getDescripcion());
						}
					} catch (Exception e) {

						if (mensajeBean.getNumero() == 0) {
							mensajeBean.setNumero(999);
						}
						mensajeBean.setDescripcion(e.getMessage());
						transaction.setRollbackOnly();
						e.printStackTrace();
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en actualiza estatus de dispersion", e);
					}
					return mensajeBean;
				}
			});
			return mensaje;

		}

	//Actualiza CifrasControl de Dispersiones
		public MensajeTransaccionBean cirreDispersion(final DispersionBean dispersionBean, final int numeroActualizacion, final long numeroTransaccion){

		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {

									String query = "call DISPERSIONACT(?,?,?,?,?,?,?,?,?,?, ?,?,?,?,?,?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);

									sentenciaStore.setInt("Par_FolioOperacion", Utileria.convierteEntero(dispersionBean.getFolioOperacion()));
									sentenciaStore.setString("Par_FechaOperacion", dispersionBean.getFechaOperacion());
									sentenciaStore.setInt("Par_Institucion", Utileria.convierteEntero(dispersionBean.getInstitucionID()));
									sentenciaStore.setLong("Par_CuentaAhoID", Utileria.convierteLong(dispersionBean.getNumCtaInstit()));
									sentenciaStore.setString("Par_NumCtaInstit",dispersionBean.getNumCtaInstit());
									sentenciaStore.setInt("Par_NumAct", numeroActualizacion);
									sentenciaStore.setString("Par_Salida",Constantes.salidaSI);

									//Parametros de OutPut
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
									sentenciaStore.registerOutParameter("Var_FolioSalida", Types.BIGINT);

									//Parametros de Auditoria
									sentenciaStore.setInt("Aud_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
									sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
									sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
									sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
									sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
									sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
									sentenciaStore.setLong("Aud_NumTransaccion", numeroTransaccion);
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
							throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
						}else if(mensajeBean.getNumero()!=0){
							throw new Exception(mensajeBean.getDescripcion());
						}
					} catch (Exception e) {

						if (mensajeBean.getNumero() == 0) {
							mensajeBean.setNumero(997);
						}
						mensajeBean.setDescripcion(e.getMessage());
						transaction.setRollbackOnly();
						e.printStackTrace();
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en cierre de dispersion", e);
					}
					return mensajeBean;
				}
			});
			return mensaje;

		}


		//Actualiza CifrasControl de Dispersiones
				public MensajeTransaccionBean actDispersionEnc(final DispersionBean dispersionBean, final int numeroActualizacion){


				MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
				transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
					public Object doInTransaction(TransactionStatus transaction) {
						MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
						try {
			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
									new CallableStatementCreator() {
										public CallableStatement createCallableStatement(Connection arg0) throws SQLException {

											String query = "call DISPERSIONACT(?,?,?,?,?,?,?,?,?,?, ?,?,?,?,?,?,?);";
											CallableStatement sentenciaStore = arg0.prepareCall(query);

											sentenciaStore.setInt("Par_FolioOperacion", Utileria.convierteEntero(dispersionBean.getFolioOperacion()));
											sentenciaStore.setString("Par_FechaOperacion", dispersionBean.getFechaOperacion());
											sentenciaStore.setInt("Par_Institucion", Utileria.convierteEntero(dispersionBean.getInstitucionID()));
											sentenciaStore.setLong("Par_CuentaAhoID", Utileria.convierteLong(dispersionBean.getNumCtaInstit()));
											sentenciaStore.setString("Par_NumCtaInstit",dispersionBean.getNumCtaInstit());
											sentenciaStore.setInt("Par_NumAct", numeroActualizacion);
											sentenciaStore.setString("Par_Salida",Constantes.salidaSI);

											//Parametros de OutPut
											sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
											sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
											sentenciaStore.registerOutParameter("Var_FolioSalida", Types.BIGINT);

											//Parametros de Auditoria
											sentenciaStore.setInt("Aud_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
											sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
											sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
											sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
											sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
											sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
											sentenciaStore.setLong("Aud_NumTransaccion", parametrosAuditoriaBean.getNumeroTransaccion());
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
									throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
								}else if(mensajeBean.getNumero()!=0){
									throw new Exception(mensajeBean.getDescripcion());
								}
							} catch (Exception e) {

								if (mensajeBean.getNumero() == 0) {
									mensajeBean.setNumero(997);
								}
								mensajeBean.setDescripcion(e.getMessage());
								transaction.setRollbackOnly();
								e.printStackTrace();
								loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en actualizacion de dispersion", e);
							}
							return mensajeBean;
						}
					});
					return mensaje;

				}

				//Importa Movimientos para realizar Dispersiones
				public MensajeTransaccionBean importaMovimientosAport(final DispersionBean dispersionBean){
					MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
					transaccionDAO.generaNumeroTransaccion();
					mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
						public Object doInTransaction(TransactionStatus transaction) {
							MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
							try{

								mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
										new CallableStatementCreator() {
											public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
												String query = "call DISPERSIONAPORTAPRO(?,?,?, ?,?,?, ?,?,?,?,?,?,?);";
												CallableStatement sentenciaStore = arg0.prepareCall(query);
												sentenciaStore.setInt("Par_InstitucionID",Utileria.convierteEntero(dispersionBean.getInstitucionID()));
												sentenciaStore.setString("Par_NumCtaInstit",dispersionBean.getNumCtaInstit());
												sentenciaStore.setDate("Par_Fecha",OperacionesFechas.conversionStrDate(dispersionBean.getFechaOperacion()));

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
									public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,DataAccessException {
										MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
										if(callableStatement.execute()){
											ResultSet resultadosStore = callableStatement.getResultSet();

											resultadosStore.next();
											mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
											mensajeTransaccion.setDescripcion(resultadosStore.getString(2));
											mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
											mensajeTransaccion.setConsecutivoInt(resultadosStore.getString(4));
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
								loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en importar movimientos de dispersion", e);

							}
							return mensajeBean;
						}
					});
					return mensaje;

				}

	//Importa Movimientos para realizar Dispersiones
	public MensajeTransaccionBean importaMovimientos(final DispersionBean dispersionBean){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try{

					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call DISPERSIONMINISPRO(?,?,?, ?,?,?, ?,?,?,?,?,?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);
									sentenciaStore.setInt("Par_InstitucionID",Utileria.convierteEntero(dispersionBean.getInstitucionID()));
									sentenciaStore.setString("Par_NumCtaInstit",dispersionBean.getNumCtaInstit());
									sentenciaStore.setDate("Par_Fecha",OperacionesFechas.conversionStrDate(dispersionBean.getFechaOperacion()));

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
						public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,DataAccessException {
							MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
							if(callableStatement.execute()){
								ResultSet resultadosStore = callableStatement.getResultSet();

								resultadosStore.next();
								mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
								mensajeTransaccion.setDescripcion(resultadosStore.getString(2));
								mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
								mensajeTransaccion.setConsecutivoInt(resultadosStore.getString(4));
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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en importar movimientos de dispersion", e);

				}
				return mensajeBean;
			}
		});
		return mensaje;

	}


	//Importa Movimientos para realizar Dispersiones de Requisicion de Gastos
	public MensajeTransaccionBean importaMovimientosReq(final DispersionBean dispersionBean){
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
							String query = "call DISPERSIONREGTOPRO(?,?,?,? ,?,?,? ,?,?,?,?,?,?,?);";
							CallableStatement sentenciaStore = arg0.prepareCall(query);
							sentenciaStore.setInt("Par_InstitucionID",Utileria.convierteEntero(dispersionBean.getInstitucionID()));
							sentenciaStore.setString("Par_NumCtaInstit",dispersionBean.getNumCtaInstit());
							sentenciaStore.setString("Par_Fecha",Utileria.convierteFecha(dispersionBean.getFechaOperacion()));
							sentenciaStore.setString("Par_FechaConsulta",Utileria.convierteFecha(dispersionBean.getFechaConsulta()));

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

							// se imprime el call del sp ejecutado en el log
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
					mensajeBean.setDescripcion(e.getMessage());
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en importar movimiento", e);
					transaction.setRollbackOnly();
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}


	//Importa Movimientos para realizar Dispersiones de Requisicion de Gastos
	public MensajeTransaccionBean importaPagosServicios(final DispersionBean dispersionBean){
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
							String query = "call DISPERSIONPASERPRO(" +
									"?,?,?,?,?, ?,?,?,?,?, ?,?,?);";
							CallableStatement sentenciaStore = arg0.prepareCall(query);
							sentenciaStore.setInt("Par_InstitucionID",Utileria.convierteEntero(dispersionBean.getInstitucionID()));
							sentenciaStore.setString("Par_NumCtaInstit",dispersionBean.getNumCtaInstit());
							sentenciaStore.setString("Par_Fecha",Utileria.convierteFecha(dispersionBean.getFechaOperacion()));

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

							// se imprime el call del sp ejecutado en el log
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
					mensajeBean.setDescripcion(e.getMessage());
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en importar pagos de servicios", e);
					transaction.setRollbackOnly();
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	//Importa pagos de anticipos de facturas
		public MensajeTransaccionBean importaAnticiposFacturas(final DispersionBean dispersionBean){
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
								String query = "call DISPERSIONANTFAPRO(?,?,	?,?,?,	?,?,?,?,?,?,?,?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);
								sentenciaStore.setInt("Par_InstitucionID",Utileria.convierteEntero(dispersionBean.getInstitucionID()));
								sentenciaStore.setString("Par_NumCtaInstit",dispersionBean.getNumCtaInstit());
								sentenciaStore.setString("Par_Fecha",Utileria.convierteFecha(dispersionBean.getFechaOperacion()));

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

								// se imprime el call del sp ejecutado en el log
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
						mensajeBean.setDescripcion(e.getMessage());
						e.printStackTrace();
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en importar el anticipo", e);
						transaction.setRollbackOnly();
					}
					return mensajeBean;
				}
			});
			return mensaje;
		}

	public DispersionBean consultaNombreCuenta(DispersionBean dispersionBean, int tipoConsulta){
		try{

			String query = "call CUENTASAHOTESOCON(?,?,?,?,?,?,?,?,?,?,?,?,?,?);";
			Object[] parametros = {
					dispersionBean.getInstitucionID(),
					dispersionBean.getCuentaAhorro(),
					dispersionBean.getNumCtaInstit(),
					tipoConsulta,
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.STRING_VACIO,

					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					"OperDispersionDAO.consultaNombreCuenta",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO
				};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CUENTASAHOTESOCON(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					DispersionBean dispersionBean = new DispersionBean();

					dispersionBean.setNumCtaInstit(resultSet.getString("NumCtaInstit"));
					dispersionBean.setNombreCuentaInst(resultSet.getString("Etiqueta"));
					dispersionBean.setCuentaAhorro(resultSet.getString("CuentaAhoID"));

					dispersionBean.setSaldoCuenta(resultSet.getString("Saldo"));
					dispersionBean.setTipoMoneda(resultSet.getString("MonedaID"));
					dispersionBean.setSobregirarSaldo(resultSet.getString("SobregirarSaldo"));
					dispersionBean.setProtecOrdenPago(resultSet.getString("ProtecOrdenPago"));
					return dispersionBean;
				}
			});

			return matches.size() > 0 ? (DispersionBean) matches.get(0) : null;

		}catch (Exception e) {
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en consulta de nombre en cuenta", e);
		}
		return dispersionBean;
	}

	/* Lista de Cuentas de Ahorro*/
	public List listaGridCuentasAho(CuentasAhoTesoBean cuentasAhoTesoBean, int tipoLista) {
		// Query con el Store Procedure
		String query = "call CUENTASAHOLIS(?,?,?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				cuentasAhoTesoBean.getCuentaAhoID(),
				tipoLista,
				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				"CreditosDAO.listaGridCuentasAho",
				parametrosAuditoriaBean.getSucursal(),
				Constantes.ENTERO_CERO };
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CUENTASAHOLIS(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum)
					throws SQLException {
				CuentasAhoTesoBean cuentasAhoTeso = new CuentasAhoTesoBean();
				cuentasAhoTeso.setCuentaAhoID(String.valueOf(resultSet.getString(1)));
				//cuentasAhoTeso.setNombreCompleto(resultSet.getString(2));
				return cuentasAhoTeso;
			}
		});

		return matches;
	}

	//Bloqueo de Saldos
	public MensajeTransaccionBean bloqueaSaldoDao(final BloqueoBean bloqueoBean,final long numTransaccion){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "call BLOQUEOSPRO(?,?,?,?,?, ?,?,?,?,? ,?,?, ?,?, ?,?,?,?,?, ?,?);";

								CallableStatement sentenciaStore = arg0.prepareCall(query);
								sentenciaStore.setString("Par_BloqueoID" ,  (bloqueoBean.getBloqueoID() != null) ? bloqueoBean.getBloqueoID() : Constantes.STRING_CERO );
								sentenciaStore.setString("Par_NatMovimiento" ,  bloqueoBean.getNatMovimiento());
								sentenciaStore.setLong("Par_CuentaAhoID" ,  Utileria.convierteLong(bloqueoBean.getCuentaAhoID()));
								sentenciaStore.setString("Par_FechaMov" ,  bloqueoBean.getFechaMov());
								sentenciaStore.setDouble("Par_MontoBloq" ,  Utileria.convierteDoble(bloqueoBean.getMontoBloq()));
								sentenciaStore.setString("Par_FechaDesbloq" ,  bloqueoBean.getFechaDesbloq());
								sentenciaStore.setInt("Par_TiposBloqID" ,  Utileria.convierteEntero(bloqueoBean.getTiposBloqID()));
								sentenciaStore.setString("Par_Descripcion" ,  bloqueoBean.getDescripcion());
								sentenciaStore.setString("Par_Referencia" , bloqueoBean.getReferencia());
								sentenciaStore.setString("Par_UsuarioClave" ,  Constantes.STRING_VACIO);
								sentenciaStore.setString("Par_ContraseniaAut" , Constantes.STRING_VACIO);
								sentenciaStore.setString("Par_Salida",Enum_Pantalla.imprime);

								//Parametros de OutPut
								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

								//Parametros de Auditoria
								sentenciaStore.setInt("Aud_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
								sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
								sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
								sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
								sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
								sentenciaStore.setInt("Aud_Sucursal", parametrosAuditoriaBean.getSucursal());
								sentenciaStore.setLong("Aud_NumTransaccion", numTransaccion);

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
									mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .BloqueoSaldoDAO.bloqueosPro");
									mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
									mensajeTransaccion.setConsecutivoString(Constantes.STRING_VACIO);
								}
								return mensajeTransaccion;
							}
						});

						if(mensajeBean ==  null){
							mensajeBean = new MensajeTransaccionBean();
							mensajeBean.setNumero(999);
							throw new Exception(Constantes.MSG_ERROR + " .OperDispersionDAO.bloqueosPro");
						}else if(mensajeBean.getNumero()!=0){
							throw new Exception(mensajeBean.getDescripcion());
						}
					} catch (Exception e) {
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Bloqueos Pro -> " + e);
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



	// Consulta si exiete Folio de Operación
	public DispersionBean conFolioOperacion(DispersionBean dispersionBean, int tipoConsulta){
		String query = "call DISPERSIONCON(?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {
				Utileria.convierteEntero(dispersionBean.getFolioOperacion()),
				tipoConsulta,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"OperDispersionDao.conFolioOperacinon",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO

				};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call DISPERSIONCON(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				DispersionBean dispersionBean = new DispersionBean();
				dispersionBean.setFechaOperacion(resultSet.getString("FechaOperacion"));
				dispersionBean.setInstitucionID(resultSet.getString("InstitucionID"));
				dispersionBean.setCuentaAhorro(resultSet.getString("CuentaAhoID"));
				dispersionBean.setEstatusEnc(resultSet.getString("Estatus"));

				return dispersionBean;
			}
		});
		return matches.size() > 0 ? (DispersionBean) matches.get(0) : null;
	}	//FIN con Folio de operacion



	public DispersionBean dispersionAutorizada(DispersionBean dispersionBean, int tipoConsulta){
		String query = "call DISPERSIONCON(?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {
				Utileria.convierteEntero(dispersionBean.getFolioOperacion()),
				tipoConsulta,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"OperDispersionDao.dispersionAutorizada",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
				};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call DISPERSIONCON(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				DispersionBean dispersionBean = new DispersionBean();
				dispersionBean.setFechaOperacion(resultSet.getString("FechaOperacion"));
				dispersionBean.setInstitucionID(resultSet.getString("InstitucionID"));
				dispersionBean.setCuentaAhorro(resultSet.getString("CuentaAhoID"));
				dispersionBean.setEstatusEnc(resultSet.getString("Estatus"));

				return dispersionBean;
			}
		});
		return matches.size() > 0 ? (DispersionBean) matches.get(0) : null;
	}

	// Consulta para obtener el Num de Transaccion de un FolioOperacion.
	public DispersionBean conNumTransaccion(DispersionBean dispersionBean, int tipoConsulta){
		String query = "call DISPERSIONCON(?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {
				Utileria.convierteEntero(dispersionBean.getFolioOperacion()),
				tipoConsulta,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"OperDispersionDao.conFolioOperacinon",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO

				};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call DISPERSIONCON(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				DispersionBean dispersionBean = new DispersionBean();
				// Se guardara en el siguiente atributo el Num de la Transaccion del Folio que se Consulto.
				dispersionBean.setFolioOperacion(resultSet.getString("NumTransaccion"));

				return dispersionBean;
			}
		});
		return matches.size() > 0 ? (DispersionBean) matches.get(0) : null;
	}

	// Consulta Institucion, NumCtaInst, Folio de Operación
		public DispersionGridBean consultaDispersionCheque(DispersionGridBean dispGridBean, int tipoConsulta){
			String query = "call DISPERSIONMOVCON(?,?,?,?,?, ?,?,?,?,?,?)";
			Object[] parametros ={
							dispGridBean.getFolioOperacion(),
				     		Constantes.ENTERO_CERO,
				     		Constantes.ENTERO_CERO,
							tipoConsulta,

							Constantes.ENTERO_CERO,
							Constantes.ENTERO_CERO,
							Constantes.FECHA_VACIA,
							Constantes.STRING_VACIO,
							"OperDispersionDao.conFolioOperacion",
							Constantes.ENTERO_CERO,
							Constantes.ENTERO_CERO
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call DISPERSIONMOVCON(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					 DispersionGridBean   dispGridBean  = new  DispersionGridBean ();
					 dispGridBean.setInstitucionID(resultSet.getString("InstitucionID"));
					 dispGridBean.setCuentaAhorro(resultSet.getString("NumCtaInstit"));
					 dispGridBean.setGridCuentaClabe(resultSet.getString("CuentaDestino"));
					 dispGridBean.setGridMonto(resultSet.getString("Monto"));
					 dispGridBean.setSucursalID(resultSet.getString("Sucursal"));
					 dispGridBean.setUsuarioID(resultSet.getString("Usuario"));
					 dispGridBean.setGridDescripcion(resultSet.getString("Descripcion"));
					 dispGridBean.setGridNombreBenefi(resultSet.getString("NombreBenefi"));
					 dispGridBean.setGridReferencia(resultSet.getString("Referencia"));

					return  dispGridBean;
				}
			});
			return matches.size() > 0 ? (DispersionGridBean) matches.get(0) : null;
		}	//FIN con Folio de operacion


		public DispersionGridBean consultaDispersionChequetem(DispersionGridBean dispGridBean, int tipoConsulta){
			String query = "call DISPERSIONMOVCON(?,?,?,?,?, ?,?,?,?,?,?)";
			Object[] parametros ={
							dispGridBean.getFolioOperacion(),
				     		Constantes.ENTERO_CERO,
				     		dispGridBean.getClaveDispersion(),
							tipoConsulta,

							Constantes.ENTERO_CERO,
							Constantes.ENTERO_CERO,
							Constantes.FECHA_VACIA,
							Constantes.STRING_VACIO,
							"OperDispersionDao.conFolioOperacion",
							Constantes.ENTERO_CERO,
							Constantes.ENTERO_CERO
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call DISPERSIONMOVCON(" + Arrays.toString(parametros) +")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					 DispersionGridBean   dispGridBean  = new  DispersionGridBean ();
					 dispGridBean.setInstitucionID(resultSet.getString("InstitucionID"));
					 dispGridBean.setCuentaAhorro(resultSet.getString("NumCtaInstit"));
					 dispGridBean.setGridCuentaClabe(resultSet.getString("CuentaDestino"));
					 dispGridBean.setGridMonto(resultSet.getString("Monto"));
					 dispGridBean.setSucursalID(resultSet.getString("Sucursal"));
					 dispGridBean.setUsuarioID(resultSet.getString("Usuario"));
					 dispGridBean.setGridDescripcion(resultSet.getString("Descripcion"));
					 dispGridBean.setGridNombreBenefi(resultSet.getString("NombreBenefi"));
					 dispGridBean.setGridReferencia(resultSet.getString("Referencia"));

					return  dispGridBean;
				}
			});
			return matches.size() > 0 ? (DispersionGridBean) matches.get(0) : null;
		}	//FIN con Folio de operacion


	// Lista de movimientos de dispersion PENDIENTE
	public List listaDispersionMovs(DispersionBean dispersionBean, int tipoConsulta){

		String query = "call DISPERSIONMOVCON(?,?,?,?,?, ?,?,?,?,?, ?)";

		Object[] parametros ={
			     		dispersionBean.getFolioOperacion(),
			     		Constantes.ENTERO_CERO,
			     		Constantes.ENTERO_CERO,
						tipoConsulta,

						Constantes.ENTERO_CERO,
						Constantes.ENTERO_CERO,
						Constantes.FECHA_VACIA,
						Constantes.STRING_VACIO,
						"OperDispersionDao.conFolioOperacinon",
						Constantes.ENTERO_CERO,
						Constantes.ENTERO_CERO
		};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call DISPERSIONMOVCON(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			@Override
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

				 DispersionGridBean   dispGridBean  = new  DispersionGridBean ();
				   dispGridBean.setClaveDispersion(resultSet.getString("ClaveDispMov"));
				   dispGridBean.setGridCuentaAhoID(resultSet.getString("CuentaCargo"));
				   dispGridBean.setCuentaContable(resultSet.getString("CuentaContable"));
				   dispGridBean.setDescCtaContable(resultSet.getString("CtaContDescrip") );
				   dispGridBean.setGridDescripcion(resultSet.getString("Descripcion"));
				   dispGridBean.setGridReferencia(resultSet.getString("Referencia"));
				   dispGridBean.setGridTipoMov(resultSet.getString("TipoMovDIspID"));
				   dispGridBean.setGridFormaPago(resultSet.getString("FormaPago"));
				   dispGridBean.setGridMonto(resultSet.getString("Monto"));
				   dispGridBean.setGridCuentaClabe(resultSet.getString("CuentaDestino"));
				   dispGridBean.setGridNombreBenefi(resultSet.getString("NombreBenefi"));
				   dispGridBean.setGridFechaEnvio(resultSet.getString("FechaEnvio").substring(0,10));
				   dispGridBean.setGridRFC(resultSet.getString("Identificacion"));
                   dispGridBean.setGridEnviados(resultSet.getString("Estatus"));
                   dispGridBean.setGridTipoChequera(resultSet.getString("TipoChequera"));
                   dispGridBean.setGridConceptoDisp(resultSet.getString("ConceptoDispersion"));
				return  dispGridBean;
			}

		});

		return matches;
	}

	//fin de la lista movsdisp

	/* Consulta de la BD para generar archivo de Dispersion */
	public List buscaDatosDispersion(int folioOperacion, int institucionID, int consulta){

			String query = "call ARCHIVODISPERSIONPRO(?,?,?,?,?,	?,?,?,?,?,		?,?);";
			Object[] parametros = {
					folioOperacion,
					institucionID,
					Constantes.STRING_VACIO,
					Constantes.STRING_VACIO,
					consulta,

					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					"OperDispersionDAO.buscaDatosDispersion",
					Constantes.ENTERO_CERO,
					parametrosAuditoriaBean.getNumeroTransaccion()
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call ARCHIVODISPERSIONPRO(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

					DispersionGridBean disperBean = new DispersionGridBean();

					disperBean.setGridTipoMov(resultSet.getString("TipoMovDIspID"));
					disperBean.setClaveDispersion(resultSet.getString("ClaveDispMov"));
					disperBean.setGridCuentaAhoID(resultSet.getString("CuentaCargo"));
					disperBean.setGridCuentaClabe(resultSet.getString("CuentaDestino"));
					disperBean.setGridMonto(resultSet.getString("Monto"));
					disperBean.setGridDescripcion(resultSet.getString("Descripcion"));
					disperBean.setGridReferencia(resultSet.getString("Referencia"));
					disperBean.setGridRFC(resultSet.getString("Identificacion"));
					disperBean.setIva(resultSet.getString("Var_iva"));
					disperBean.setFechaAplicar(resultSet.getString("FechaEnvio"));
					disperBean.setNombreBeneficiario(resultSet.getString("NombreBenefi"));

					loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"clave: "+disperBean.getClaveDispersion());

					return disperBean;
				}
			});

		return matches;
	}

	/* Consulta de la BD para generar archivo de Dispersion */
	public List buscaDatosDispersionBancomer( final int folioOperacion, int institucionID, int consulta){

			String query = "call ARCHIVODISPERSIONPRO(?,?,?,?,?,		?,?,?,?,?,		?,?);";
			Object[] parametros = {
					folioOperacion,
					institucionID,
					Constantes.STRING_VACIO,
					Constantes.STRING_VACIO,
					consulta,

					parametrosAuditoriaBean.getEmpresaID(),
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					"OperDispersionDAO.buscaDatosDispersion",
					Constantes.ENTERO_CERO,
					parametrosAuditoriaBean.getNumeroTransaccion()
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call ARCHIVODISPERSIONPRO(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

					DispersionGridBean disperBean = new DispersionGridBean();

					disperBean.setGridCuentaClabe(resultSet.getString("CuentaAbono"));
					disperBean.setGridCuentaAhoID(resultSet.getString("CuentaCargo"));
					disperBean.setGridMonto(resultSet.getString("Monto"));
					disperBean.setNombreBeneficiario(resultSet.getString("Beneficiario"));
					disperBean.setGridDescripcion(resultSet.getString("Descripcion"));
					disperBean.setGridReferencia(resultSet.getString("Referencia"));
					disperBean.setGridRFC(resultSet.getString("RFC"));
					disperBean.setGridFormaPago(resultSet.getString("Moneda"));
					loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"clave: "+disperBean.getClaveDispersion());
					return disperBean;
				}
			});

		return matches;
	}





	//modificar encabezado
	public MensajeTransaccionBean modificarEncabezado( DispersionBean dispersionBean){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		try{

			String query = "call DISPERSIONMOD(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?);";
			Object[] parametros = {
					Utileria.convierteEntero(dispersionBean.getFolioOperacion()),
					parametrosAuditoriaBean.getFecha(),
					Utileria.convierteEntero(dispersionBean.getInstitucionID()),
					Utileria.convierteEntero(dispersionBean.getNumCtaInstit()),
					3,//  Par_CantRegistros
					2,//  Par_CantEnviados
					500.12,//Par_MontoTotal
					3.2344,//  Par_MontoEnviado
                    "Es",//  Par_Estatus
					parametrosAuditoriaBean.getEmpresaID(),
					parametrosAuditoriaBean.getUsuario(),
					parametrosAuditoriaBean.getFecha(),
					parametrosAuditoriaBean.getDireccionIP(),
					"OperDispersionDao.alta",
					parametrosAuditoriaBean.getSucursal(),
					parametrosAuditoriaBean.getNumeroTransaccion()


			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call DISPERSIONMOD(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum)
						throws SQLException {
					MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
					mensaje.setNumero(Integer.valueOf(resultSet.getString(1)).intValue());
					mensaje.setDescripcion(resultSet.getString(2));
					mensaje.setNombreControl(resultSet.getString(3));
					mensaje.setConsecutivoString(resultSet.getString(4));
					mensaje.setConsecutivoInt(resultSet.getString(4));
					return mensaje;
				}
			});
			mensaje = matches.size() > 0 ? (MensajeTransaccionBean) matches.get(0) : null;
			return mensaje;

		} catch (Exception e) {
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en modificar encabezado", e);
			if(mensaje.getNumero()==0){
				mensaje.setNumero(999);
			}
			mensaje.setDescripcion(e.getMessage());
		}

		return mensaje;
	}//fin modificar encabezado

	// Modificar cuerpo
	public MensajeTransaccionBean modificaCuerpo(final DispersionGridBean dispersionGridBean,final int folioOperacion){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();

		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call DISPERSIONMOVMOD(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);

									sentenciaStore.setInt("Par_ClaveDispMov", Utileria.convierteEntero(dispersionGridBean.getClaveDispersion()));
									sentenciaStore.setInt("Par_DispersionID",folioOperacion);
									sentenciaStore.setLong("Par_CuentaCargo", Utileria.convierteLong(dispersionGridBean.getGridCuentaAhoID()));
									sentenciaStore.setString("Par_Descripcion", dispersionGridBean.getGridDescripcion());
									sentenciaStore.setString("Par_Referencia", dispersionGridBean.getGridReferencia());
									sentenciaStore.setInt("Par_TipoMovDIspID", Utileria.convierteEntero(dispersionGridBean.getGridTipoMov()));
									sentenciaStore.setInt("Par_FormaPago", Utileria.convierteEntero(dispersionGridBean.getGridFormaPago()));
									sentenciaStore.setDouble("Par_Monto", Utileria.convierteDoble(dispersionGridBean.getGridMonto()));
									sentenciaStore.setString("Par_CuentaDestino", dispersionGridBean.getGridCuentaClabe());
									sentenciaStore.setString("Par_Identificacion", dispersionGridBean.getGridRFC());
									sentenciaStore.setString("Par_Estatus", dispersionGridBean.getGridEnviados());
									sentenciaStore.setString("Par_NombreBenefi", dispersionGridBean.getGridNombreBenefi());
									sentenciaStore.setDate("Par_FechaEnvio", parametrosAuditoriaBean.getFecha());
									sentenciaStore.setString("Par_TipoChequera", dispersionGridBean.getGridTipoChequera());

								    //Parametros de OutPut
								    sentenciaStore.setString("Par_Salida",salidaPantalla);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

									//Parametros de Auditoria
									sentenciaStore.setInt("Aud_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
									sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
									sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
									sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
									sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
									sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
									sentenciaStore.setLong("Aud_NumTransaccion", parametrosAuditoriaBean.getNumeroTransaccion());

									loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());

									return sentenciaStore;
								}
							},new CallableStatementCallback() {
								public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException, DataAccessException {
									MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
									MensajeTransaccionBean mensajeBloqueo = null;

									if(callableStatement.execute()){
										ResultSet resultadosStore = callableStatement.getResultSet();

										resultadosStore.next();

										mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString("NumErr")).intValue());
										mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
										mensajeTransaccion.setNombreControl(resultadosStore.getString("control"));
										mensajeTransaccion.setConsecutivoInt(resultadosStore.getString("consecutivo"));


									}else{
										mensajeTransaccion.setNumero(999);
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .OperDispersionDAO.modificaCuerpo");
									}
									return mensajeTransaccion;
								}
							});

					} catch (Exception e) {
						e.printStackTrace();
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en modificacion del cuerpo de dispersion", e);
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



	public List listaFoliosEstatusAbierto(DispersionBean dispersionBean, int tipoLista){
		List foliosDispersionLis = null;
		try{
			String query = "call DISPERSIONLIS(?,?,?,?,?,?,?,?,?);";
			Object[] parametros = {
					dispersionBean.getInstitucionID(),
					tipoLista,

					parametrosAuditoriaBean.getEmpresaID(),
					parametrosAuditoriaBean.getUsuario(),
					parametrosAuditoriaBean.getFecha(),
					parametrosAuditoriaBean.getDireccionIP(),
					parametrosAuditoriaBean.getNombrePrograma(),
					parametrosAuditoriaBean.getSucursal(),
					Constantes.ENTERO_CERO
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call DISPERSIONLIS(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					DispersionBean dispersionBean = new DispersionBean();
					dispersionBean.setFolioOperacion(Utileria.completaCerosIzquierda(resultSet.getString(1),3));
					dispersionBean.setNombreCorto(resultSet.getString(2));
					dispersionBean.setNumCtaInstit(resultSet.getString(3));
					dispersionBean.setFechaOperacion(resultSet.getString(4));
					return dispersionBean;
				}
			});
			foliosDispersionLis= matches;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en lista de folios en estatus abiertos", e);
		}
		return foliosDispersionLis;
	}


	public List listaFoliosAExportar(DispersionBean dispersionBean, int tipoLista){
		List foliosDispersionLis = null;
		try{
			String query = "call DISPERSIONLIS(?,?,?,?,?,?,?,?,?);";
			Object[] parametros = {
					dispersionBean.getInstitucionID(),
					tipoLista,

					parametrosAuditoriaBean.getEmpresaID(),
					parametrosAuditoriaBean.getUsuario(),
					parametrosAuditoriaBean.getFecha(),
					parametrosAuditoriaBean.getDireccionIP(),
					parametrosAuditoriaBean.getNombrePrograma(),
					parametrosAuditoriaBean.getSucursal(),
					Constantes.ENTERO_CERO
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call DISPERSIONLIS(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					DispersionBean dispersionBean = new DispersionBean();
					dispersionBean.setFolioOperacion(Utileria.completaCerosIzquierda(resultSet.getString(1),3));
					dispersionBean.setNombreCorto(resultSet.getString(2));
					dispersionBean.setNumCtaInstit(resultSet.getString(3));
					dispersionBean.setFechaOperacion(resultSet.getString(4));
					return dispersionBean;
				}
			});
			foliosDispersionLis= matches;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en lista de folios a exportar ", e);
		}
		return foliosDispersionLis;
	}

	//METODO PARA GENERAR EL ENCABEZADO DE LAS ORDENES DE PAGO (BANCOMER)
			public List  listaReportesProteccionEnc(final DispersionBean dispersionBean, int tipolista){



				List listaResultado = null;
				try{

					String query = "call PROTECORDENPAGOLIS(?,?,?,?,?, ?,?,?,?,?,?)";

					Object[] parametros ={
										Utileria.convierteEntero(dispersionBean.getFolioOperacion()),
										Utileria.convierteEntero(dispersionBean.getInstitucionID()),
										dispersionBean.getCuentaAhorro(),
										tipolista,

										parametrosAuditoriaBean.getEmpresaID(),
										parametrosAuditoriaBean.getUsuario(),
										parametrosAuditoriaBean.getFecha(),
										parametrosAuditoriaBean.getDireccionIP(),
										"OperDispersionDAO.proteccionOrdenPag",
										parametrosAuditoriaBean.getSucursal(),
										Constantes.ENTERO_CERO};
					loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PROTECORDENPAGOLIS(  " + Arrays.toString(parametros) + ")");
						List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
						public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
							ProteccionOrdenPagoBean proteccionOrdenPago= new ProteccionOrdenPagoBean();
							proteccionOrdenPago.setColumna1(resultSet.getString("Encabezado"));
							proteccionOrdenPago.setColumna2(resultSet.getString("NumConvenio"));
							proteccionOrdenPago.setColumna3(resultSet.getString("FechaEnvio"));
							proteccionOrdenPago.setColumna4(resultSet.getString("Concepto"));
							proteccionOrdenPago.setColumna5(resultSet.getString("Confirmacion"));
							proteccionOrdenPago.setColumna6(resultSet.getString("Canal"));
							proteccionOrdenPago.setColumna7(resultSet.getString("CuentaCargo"));
							proteccionOrdenPago.setColumna8(resultSet.getString("Campo1"));
							proteccionOrdenPago.setColumna9(resultSet.getString("Divisa"));
							proteccionOrdenPago.setColumna10(resultSet.getString("Campo2"));

							return proteccionOrdenPago ;
						}
					});
					listaResultado = matches;

				} catch (Exception e) {
					 e.printStackTrace();
					 loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en generacion de reporte de proteccion orden de pago ", e);
				}
					return listaResultado;
			}

	//METODO PARA GENERAR EL DETALLE DE LAS ORDENES DE PAGO (BANCOMER)
		public List  listaReportesProteccion(final DispersionBean dispersionBean, int tipolista){



			List listaResultado = null;
			try{

				String query = "call PROTECORDENPAGOLIS(?,?,?,?,?, ?,?,?,?,?,?)";

				Object[] parametros ={
									Utileria.convierteEntero(dispersionBean.getFolioOperacion()),
									Utileria.convierteEntero(dispersionBean.getInstitucionID()),
									dispersionBean.getCuentaAhorro(),
									tipolista,

									parametrosAuditoriaBean.getEmpresaID(),
									parametrosAuditoriaBean.getUsuario(),
									parametrosAuditoriaBean.getFecha(),
									parametrosAuditoriaBean.getDireccionIP(),
									"OperDispersionDAO.proteccionOrdenPag",
									parametrosAuditoriaBean.getSucursal(),
									Constantes.ENTERO_CERO};
				loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PROTECORDENPAGOLIS(  " + Arrays.toString(parametros) + ")");
					List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
					public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
						ProteccionOrdenPagoBean proteccionOrdenPago= new ProteccionOrdenPagoBean();
						proteccionOrdenPago.setDetalle(resultSet.getString("Detalle"));
						proteccionOrdenPago.setAlta(resultSet.getString("Alta"));
						proteccionOrdenPago.setCuentaNum(resultSet.getString("CtaNum"));
						proteccionOrdenPago.setConcepto(resultSet.getString("Concepto"));
						proteccionOrdenPago.setPagoVent(resultSet.getString("PagoVentanilla"));
						proteccionOrdenPago.setCodigopagoVent(resultSet.getString("CodPagoVent"));
						proteccionOrdenPago.setNoPagoInt(resultSet.getString("NoPagosInter"));
						proteccionOrdenPago.setReferencia(resultSet.getString("Referencia"));
						proteccionOrdenPago.setBeneficiario(resultSet.getString("Beneficiario"));
						proteccionOrdenPago.setIdentificacion(resultSet.getString("Identificacion"));
						proteccionOrdenPago.setDivisa(resultSet.getString("Divisa"));
						proteccionOrdenPago.setMonto(resultSet.getString("Monto"));
						proteccionOrdenPago.setConfirmacion(resultSet.getString("Confirmacion"));
						proteccionOrdenPago.setCorreoCel(resultSet.getString("CorreoCel"));
						proteccionOrdenPago.setFechaDispersion(resultSet.getString("FechaDisp"));
						proteccionOrdenPago.setFechaVenci(resultSet.getString("FechaVen"));
						proteccionOrdenPago.setEstatus(resultSet.getString("Estatus"));
						proteccionOrdenPago.setDescEstatus(resultSet.getString("DescEstatus"));

						return proteccionOrdenPago ;
					}
				});
				listaResultado = matches;

			} catch (Exception e) {
				 e.printStackTrace();
				 loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en generacion de reporte de proteccion orden de pago ", e);
			}
				return listaResultado;
		}
		//METODO PARA CONSULTA PARA REPORTE DE DISPERCIONES EN EXCEL
		public List consultaRepDispersionesExcel(final DispersionBean dispersionBean, int tipoLista ){
			List ListaResultado=null;
			try{
			String query = "call DISPERSIONREP(?,?,?,?,?,?,?,?,?,?, ?,?,?,?,?)";

			Object[] parametros ={
								Utileria.convierteFecha(dispersionBean.getFechaInicio()),
								Utileria.convierteFecha(dispersionBean.getFechaFin()),
								Utileria.convierteEntero(dispersionBean.getInstitucionID()),
								Utileria.convierteEntero(dispersionBean.getCuentaAhorro()),
								dispersionBean.getEstatusEnc(),
								dispersionBean.getEstatusDet(),
								Utileria.convierteEntero(dispersionBean.getSucursal()),
								Utileria.convierteEntero(dispersionBean.getFormaPagoID()),

					    		parametrosAuditoriaBean.getEmpresaID(),
								parametrosAuditoriaBean.getUsuario(),
								parametrosAuditoriaBean.getFecha(),
								parametrosAuditoriaBean.getDireccionIP(),
								parametrosAuditoriaBean.getNombrePrograma(),
								parametrosAuditoriaBean.getSucursal(),
								Constantes.ENTERO_CERO};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call DISPERSIONREP(  " + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					ReporteDispersionBean repDispersionBean= new ReporteDispersionBean();

					repDispersionBean.setFolioOperacion(resultSet.getString("FolioOperacion"));
					repDispersionBean.setFechaOperacion(resultSet.getString("FechaOperacion"));
					repDispersionBean.setEstatusEnc(resultSet.getString("EstatusEnc"));
					repDispersionBean.setSucursal(resultSet.getString("Sucursal"));
					repDispersionBean.setNombreSucurs(resultSet.getString("NombreSucurs"));
					repDispersionBean.setCuentaCargo(resultSet.getString("CuentaCargo"));
					repDispersionBean.setNombreCompleto(resultSet.getString("NombreCompleto"));
					repDispersionBean.setDescriMov(resultSet.getString("DescriMov"));
					repDispersionBean.setReferencia(resultSet.getString("Referencia"));
					repDispersionBean.setTipoMovDispID(resultSet.getString("TipoMovDispID"));
					repDispersionBean.setDescripcion(resultSet.getString("Descripcion"));
					repDispersionBean.setFormaPago(resultSet.getString("FormaPago"));
					repDispersionBean.setMonto(resultSet.getString("Monto"));
					repDispersionBean.setCuentaDestino(resultSet.getString("CuentaDestino"));
					repDispersionBean.setNombreBenefi(resultSet.getString("NombreBenefi"));
					repDispersionBean.setEstatusDet(resultSet.getString("EstatusDet"));
					repDispersionBean.setNumTransaccion(resultSet.getString("NumTransaccion"));
					repDispersionBean.setPolizaID(resultSet.getString("PolizaID"));
					repDispersionBean.setConcepto(resultSet.getString("Concepto"));
					repDispersionBean.setEstatusRef(resultSet.getString("EstatusRef"));
					repDispersionBean.setEstatusTranSan(resultSet.getString("EstatusTraSan"));

					return repDispersionBean ;
				}
			});
			ListaResultado= matches;
			}catch(Exception e){
				 e.printStackTrace();
				 loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en consulta de reprte de Dispersiones", e);
			}
			return ListaResultado;
		}
		//METODO PARA GENERAR EL SUMARIO DE LAS ORDENES DE PAGO (BANCOMER)
		public List  listaReportesProteccionFin(final DispersionBean dispersionBean, int tipolista){



			List listaResultado = null;
			try{

				String query = "call PROTECORDENPAGOLIS(?,?,?,?,?, ?,?,?,?,?,?)";

				Object[] parametros ={
									Utileria.convierteEntero(dispersionBean.getFolioOperacion()),
									Utileria.convierteEntero(dispersionBean.getInstitucionID()),
									dispersionBean.getCuentaAhorro(),
									tipolista,

									parametrosAuditoriaBean.getEmpresaID(),
									parametrosAuditoriaBean.getUsuario(),
									parametrosAuditoriaBean.getFecha(),
									parametrosAuditoriaBean.getDireccionIP(),
									"OperDispersionDAO.proteccionOrdenPag",
									parametrosAuditoriaBean.getSucursal(),
									Constantes.ENTERO_CERO};
				loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PROTECORDENPAGOLIS(  " + Arrays.toString(parametros) + ")");
					List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
					public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
						ProteccionOrdenPagoBean proteccionOrdenPago= new ProteccionOrdenPagoBean();
						proteccionOrdenPago.setColumna1(resultSet.getString("Encabezado"));
						proteccionOrdenPago.setColumna2(resultSet.getString("TotalRegistros"));
						proteccionOrdenPago.setColumna3(resultSet.getString("MontoTotal"));
						proteccionOrdenPago.setColumna4(resultSet.getString("CincoCeros"));
						proteccionOrdenPago.setColumna5(resultSet.getString("QuinceCeros"));
						proteccionOrdenPago.setColumna6(resultSet.getString("CuatroCeros"));
						proteccionOrdenPago.setColumna7(resultSet.getString("NueveCeros"));
						proteccionOrdenPago.setColumna8(resultSet.getString("CincoEspacios"));

						return proteccionOrdenPago ;
					}
				});
				listaResultado = matches;

			} catch (Exception e) {
				 e.printStackTrace();
				 loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en generacion de reporte de proteccion orden de pago ", e);
			}
				return listaResultado;
		}

	public MensajeTransaccionBean importaBonificaciones(final DispersionBean dispersionBean){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try{

					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call DISPERSIONBONIFICAPRO(?,?,?, ?,?,?, ?,?,?,?,?,?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);
									sentenciaStore.setInt("Par_InstitucionID",Utileria.convierteEntero(dispersionBean.getInstitucionID()));
									sentenciaStore.setString("Par_NumCtaInstit",dispersionBean.getNumCtaInstit());
									sentenciaStore.setDate("Par_Fecha",OperacionesFechas.conversionStrDate(dispersionBean.getFechaOperacion()));

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
						public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,DataAccessException {
							MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
							if(callableStatement.execute()){
								ResultSet resultadosStore = callableStatement.getResultSet();

								resultadosStore.next();
								mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
								mensajeTransaccion.setDescripcion(resultadosStore.getString(2));
								mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
								mensajeTransaccion.setConsecutivoInt(resultadosStore.getString(4));
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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en importar movimientos de dispersion", e);

				}
				return mensajeBean;
			}
		});
		return mensaje;

	}

	/* Consulta de la BD para generar archivo de Dispersion de transferencia santander*/
	public List buscaDatosDispersionSantander( final int folioOperacion, int institucionID, int consulta, String tipoArchivo, String NombreArchivo){

			String query = "call ARCHIVODISPERSIONPRO(?,?,?,?,?,		?,?,?,?,?,		?,?);";
			Object[] parametros = {
					folioOperacion,
					institucionID,
					tipoArchivo,
					NombreArchivo,
					consulta,

					parametrosAuditoriaBean.getEmpresaID(),
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					"OperDispersionDAO.buscaDatosDispersion",
					Constantes.ENTERO_CERO,
					parametrosAuditoriaBean.getNumeroTransaccion()
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call ARCHIVODISPERSIONPRO(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

					DispersionGridBean disperBean = new DispersionGridBean();
					disperBean.setCodigoLayaut(resultSet.getString("CodigoLayaut"));
					disperBean.setGridCuentaClabe(resultSet.getString("CuentaAbono"));
					disperBean.setGridCuentaAhoID(resultSet.getString("CuentaCargo"));
					disperBean.setGridMonto(resultSet.getString("Monto"));
					disperBean.setGridDescripcion(resultSet.getString("Descripcion"));

					disperBean.setConcepto(resultSet.getString("Concepto"));
					disperBean.setCorreoBeneficiario(resultSet.getString("CorreoBeneficiario"));
					disperBean.setNombreBeneficiario(resultSet.getString("Beneficiario"));
					disperBean.setGridReferencia(resultSet.getString("Referencia"));
					disperBean.setGridRFC(resultSet.getString("RFC"));

					disperBean.setGridFormaPago(resultSet.getString("Moneda"));
					disperBean.setFechaAplicacion(resultSet.getString("FechaSistema"));

					loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"clave: "+disperBean.getClaveDispersion());
					return disperBean;
				}
			});

		return matches;
	}

	/* Consulta de la BD para generar archivo de Dispersion de transferencias de otros a traves de Santander*/
	public List buscaDatosDispersionCanc( final long folioOperacion, int institucionID, int consulta, String tipoArchivo, String NombreArchivo){

		String query = "call DISPERSIONMOVLIS(?,?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				1,

				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				parametrosAuditoriaBean.getNombrePrograma(),
				parametrosAuditoriaBean.getSucursal(),
				folioOperacion
		};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call DISPERSIONMOVLIS(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

				DispersionGridBean disperBean = new DispersionGridBean();
				disperBean.setNumeroOrden(resultSet.getString("NumeroOrden"));

				loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"clave: "+disperBean.getClaveDispersion());
				return disperBean;
			}
		});

		return matches;
	}
	public List buscaDatosDispersionOtrosSantander( final int folioOperacion, int institucionID, int consulta, String tipoArchivo, String NombreArchivo){

			String query = "call ARCHIVODISPERSIONPRO(?,?,?,?,?,		?,?,?,?,?,		?,?);";
			Object[] parametros = {
					folioOperacion,
					institucionID,
					tipoArchivo,
					NombreArchivo,
					consulta,

					parametrosAuditoriaBean.getEmpresaID(),
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					"OperDispersionDAO.buscaDatosDispersion",
					Constantes.ENTERO_CERO,
					parametrosAuditoriaBean.getNumeroTransaccion()
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call ARCHIVODISPERSIONPRO(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

					DispersionGridBean disperBean = new DispersionGridBean();
					disperBean.setCodigoLayaut(resultSet.getString("CodigoLayaut"));
					disperBean.setGridCuentaClabe(resultSet.getString("CuentaAbono"));
					disperBean.setGridCuentaAhoID(resultSet.getString("CuentaCargo"));
					disperBean.setBancoReceptor(resultSet.getString("BancoReceptor"));
					disperBean.setNombreBeneficiario(resultSet.getString("Beneficiario"));

					disperBean.setSucursalID(resultSet.getString("SucursalID"));
					disperBean.setGridMonto(resultSet.getString("Monto"));
					disperBean.setPlazaBanxico(resultSet.getString("PlazaBanxico"));
					disperBean.setConcepto(resultSet.getString("Concepto"));
					disperBean.setGridReferencia(resultSet.getString("Referencia"));

					disperBean.setCorreoBeneficiario(resultSet.getString("CorreoBeneficiario"));
					disperBean.setGridDescripcion(resultSet.getString("Descripcion"));
					disperBean.setGridRFC(resultSet.getString("RFC"));
					disperBean.setGridFormaPago(resultSet.getString("Moneda"));

					loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"clave: "+disperBean.getClaveDispersion());
					return disperBean;
				}
			});

		return matches;
	}

	/* Consulta de la BD para generar archivo de Dispersion de orden de pago*/
	public List buscaDatosDispOrdenpagSan( final int folioOperacion, int institucionID, int consulta, String tipoArchivo, String NombreArchivo){

			String query = "call ARCHIVODISPERSIONPRO(?,?,?,?,?,		?,?,?,?,?,		?,?);";
			Object[] parametros = {
					folioOperacion,
					institucionID,
					tipoArchivo,
					NombreArchivo,
					consulta,

					parametrosAuditoriaBean.getEmpresaID(),
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					"OperDispersionDAO.buscaDatosDispersion",
					Constantes.ENTERO_CERO,
					parametrosAuditoriaBean.getNumeroTransaccion()
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call ARCHIVODISPERSIONPRO(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

					DispersionGridBean disperBean = new DispersionGridBean();

					disperBean.setGridCuentaAhoID(resultSet.getString("CuentaCargo"));
					disperBean.setClaveDispersion(resultSet.getString("ClaveDispMov"));
					disperBean.setFechaAplicacion(resultSet.getString("FechaSistema"));
					disperBean.setFechaAplicar(resultSet.getString("FechaEnvio"));
					disperBean.setGridRFC(resultSet.getString("RFC"));
					disperBean.setNombreBeneficiario(resultSet.getString("Beneficiario"));
					disperBean.setClaveSucursales(resultSet.getString("ClaveSucursales"));
					disperBean.setClaveSucursal(resultSet.getString("ClaveSucursal"));
					disperBean.setTipoPago(resultSet.getString("TipoPago"));
					disperBean.setGridMonto(resultSet.getString("Monto"));
					disperBean.setConcepto(resultSet.getString("Concepto"));

					loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"clave: "+disperBean.getClaveDispersion());
					return disperBean;

				}
			});

		return matches;
	}


	// Consulta para obtener si el folio cotiene orden de pagos y transferencias
		public DispersionBean conDispTransOrderPag(DispersionBean dispersionBean, int tipoConsulta){
			String query = "call DISPERSIONCON(?,?,?,?,?,?,?,?,?);";
			Object[] parametros = {
					Utileria.convierteEntero(dispersionBean.getFolioOperacion()),
					tipoConsulta,

					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					"OperDispersionDao.conFolioOperacinon",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO

					};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call DISPERSIONCON(" + Arrays.toString(parametros) +")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					DispersionBean dispersionBean = new DispersionBean();
					dispersionBean.setContDispTrans(resultSet.getString("ContDispTrans"));
					dispersionBean.setContDispOrdpag(resultSet.getString("ContDispOrdpag"));

					return dispersionBean;
				}
			});
			return matches.size() > 0 ? (DispersionBean) matches.get(0) : null;
		}

		// LISTA PARA CANCELAR LA ORDEN DE PAGO
		public List listaCancelaOrdPag(DispersionBean dispersionBean, int tipoLista){
			List foliosDispersionLis = null;
			try{
				String query = "call DISPERSIONMOVLIS(?,?,?,?,?,?,?,?,?,?);";
				Object[] parametros = {
						dispersionBean.getNombreCompleto(),
						dispersionBean.getReferenciaDisp(),
						tipoLista,

						parametrosAuditoriaBean.getEmpresaID(),
						parametrosAuditoriaBean.getUsuario(),
						parametrosAuditoriaBean.getFecha(),
						parametrosAuditoriaBean.getDireccionIP(),
						parametrosAuditoriaBean.getNombrePrograma(),
						parametrosAuditoriaBean.getSucursal(),
						Constantes.ENTERO_CERO
				};
				loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call DISPERSIONMOVLIS(" + Arrays.toString(parametros) +")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
					public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
						DispersionBean dispersionBean = new DispersionBean();
						dispersionBean.setSolicitudCreditoID(resultSet.getString("SolicitudCreditoID"));
						dispersionBean.setNombreCompleto(resultSet.getString("NombreCompleto"));
						dispersionBean.setCreditoID(resultSet.getString("CreditoID"));
						dispersionBean.setCuentaDestino(resultSet.getString("CuentaDestino"));
						dispersionBean.setMontoDisp(resultSet.getString("Monto"));
						dispersionBean.setDispersionID(resultSet.getString("DispersionID"));
						dispersionBean.setClaveDispMovID(resultSet.getString("ClaveDispMov"));
						dispersionBean.setEstatusDisp(resultSet.getString("Estatus"));
						return dispersionBean;
					}
				});
				foliosDispersionLis= matches;
			}catch(Exception e){
				e.printStackTrace();
				loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en lista de folios a exportar ", e);
			}
			return foliosDispersionLis;
		}

		// Consulta para obtener la info. de ordenes de pago por solicitud o referencia
		public DispersionBean conDispOrderPag(DispersionBean dispersionBean, int tipoConsulta){
			String query = "call DISPERSIONMOVSCON(?,?,?,?,?,?,?,?,?,?);";
			Object[] parametros = {
					Utileria.convierteEntero(dispersionBean.getSolicitudCreditoID()),
					dispersionBean.getReferenciaDisp(),
					tipoConsulta,

					parametrosAuditoriaBean.getEmpresaID(),
					parametrosAuditoriaBean.getUsuario(),
					parametrosAuditoriaBean.getFecha(),
					parametrosAuditoriaBean.getDireccionIP(),
					parametrosAuditoriaBean.getNombrePrograma(),
					parametrosAuditoriaBean.getSucursal(),
					Constantes.ENTERO_CERO

					};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call DISPERSIONMOVSCON(" + Arrays.toString(parametros) +")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					DispersionBean dispersionBean = new DispersionBean();
					dispersionBean.setSolicitudCreditoID(resultSet.getString("SolicitudCreditoID"));
					dispersionBean.setNombreCompleto(resultSet.getString("NombreCompleto"));
					dispersionBean.setCreditoID(resultSet.getString("CreditoID"));
					dispersionBean.setCuentaDestino(resultSet.getString("CuentaDestino"));
					dispersionBean.setMontoDisp(resultSet.getString("Monto"));
					dispersionBean.setDispersionID(resultSet.getString("DispersionID"));
					dispersionBean.setClaveDispMovID(resultSet.getString("ClaveDispMov"));
					dispersionBean.setEstatusDisp(resultSet.getString("Estatus"));

					return dispersionBean;
				}
			});
			return matches.size() > 0 ? (DispersionBean) matches.get(0) : null;
		}


	public PolizaDAO getPolizaDAO() {
		return polizaDAO;
	}

	public void setPolizaDAO(PolizaDAO polizaDAO) {
		this.polizaDAO = polizaDAO;
	}

	public ChequesEmitidosDAO getChequesEmitidosDAO() {
		return chequesEmitidosDAO;
	}

	public void setChequesEmitidosDAO(ChequesEmitidosDAO chequesEmitidosDAO) {
		this.chequesEmitidosDAO = chequesEmitidosDAO;
	}

	public RenovacionOrdenPagoDAO getRenovacionOrdenPagoDAO() {
		return renovacionOrdenPagoDAO;
	}

	public void setRenovacionOrdenPagoDAO(
			RenovacionOrdenPagoDAO renovacionOrdenPagoDAO) {
		this.renovacionOrdenPagoDAO = renovacionOrdenPagoDAO;
	}

}
