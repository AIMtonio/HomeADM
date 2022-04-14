package tesoreria.dao;
import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.OperacionesFechas;
import herramientas.Utileria;

import java.io.BufferedReader;
import java.io.FileReader;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.Iterator;
import java.util.List;

import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.CallableStatementCallback;
import org.springframework.jdbc.core.CallableStatementCreator;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;
import org.springframework.transaction.support.TransactionTemplate;

import pld.bean.PLDListasPersBloqBean;
import pld.bean.SeguimientoPersonaListaBean;
import pld.dao.PLDListasPersBloqDAO;
import pld.dao.SeguimientoPersonaListaDAO;
import soporte.bean.ProcesosETLBean;
import soporte.dao.ProcesosETLDAO;
import tesoreria.bean.CatCodigoLeyendaBean;
import tesoreria.bean.DepositosRefeBean;
import tesoreria.bean.ReferenciasPagosBean;
import tesoreria.bean.ResultadoCargaArchivosTesoreriaBean;
import tesoreria.servicio.DepositosRefeServicio.Enum_Tra_Inserta;
import credito.bean.CreditosBean;
import credito.dao.CreditosDAO;
import cuentas.bean.CuentasAhoBean;
import cuentas.dao.CuentasAhoDAO;


public class DepositosRefeDAO  extends BaseDAO{
	public static interface Enum_Tra_NatMovimi {
		String abono = "A";
		String vacio = " ";
	}

	public static interface Enum_TiposBancos {
		int BANAMEX = 9;
		int BANORTE = 27;
	}

	CuentasAhoDAO cuentasAhoDAO = null;
	ReferenciasPagosDAO referenciasPagosDAO = null;
	CreditosDAO creditosDAO = null;
	PLDListasPersBloqDAO pldListasPersBloqDAO = null;
	SeguimientoPersonaListaDAO seguimientoPersonaListaDAO = null;
	ProcesosETLDAO procesosETLDAO = null;

	final	String saltoLinea=" <br> ";
	/**
	 * Guarda los registros de los depósitos referenciados en la tabla de validación.
	 * @param refeBean Valores de los depósitos a cargar.
	 * @param result Resultado de la carga.
	 * @param institucionID Número de institución bancaria.
	 * @param accion Indica si registra los datos en la tabla.
	 * @param numeroTransaccion Número de transacción.
	 * @return {@linkplain ResultadoCargaArchivosTesoreriaBean} con el resultado de la carga.
	 */
	public ResultadoCargaArchivosTesoreriaBean altaDepositosRefere(final DepositosRefeBean refeBean, final ResultadoCargaArchivosTesoreriaBean result,
			final int institucionID, final String accion,final long numeroTransaccion ){
		ResultadoCargaArchivosTesoreriaBean resultCarga = new ResultadoCargaArchivosTesoreriaBean();
		resultCarga = (ResultadoCargaArchivosTesoreriaBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
				new TransactionCallback<Object>() {
					public Object doInTransaction(TransactionStatus transaction) {
						try {
							MensajeTransaccionBean mensaje = null;

							/**Realiza la inserción de los datos leidos en el archivo en la tabla temporal*/
							mensaje = procesoDepositoRefere(refeBean, numeroTransaccion, accion);

							result.setNumero(mensaje.getNumero());
							result.setDescripcion(mensaje.getDescripcion());
							result.setConsecutivoInt(mensaje.getConsecutivoInt());

							/**Estas condiciones son para ir sumando el numero de exitosos y fallidos
							 * en este caso no se requieren, pero se dejo el codigoo pues no causa problemas*/
							if(mensaje.getNumero()==0){
								result.setExitosos(result.getExitosos()+1);
							}else{
								result.setFallidos(result.getFallidos()+1);
								result.setDescripcion(mensaje.getDescripcion());
							}
						} catch (Exception e) {
							e.printStackTrace();
							loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta de deposito referenciado", e);
							transaction.setRollbackOnly();
							result.setFallidos(result.getFallidos()+1);
						}
						return result;
					}
				});
		return result;
	}
	/**
	 * Guarda los registros de los depósitos referenciados en la tabla de validación.
	 * @param refeBean Valores de los depósitos a cargar.
	 * @param result Resultado de la carga.
	 * @param institucionID Número de institución bancaria.
	 * @param accion Indica si registra los datos en la tabla.
	 * @param numeroTransaccion Número de transacción.
	 * @return {@linkplain ResultadoCargaArchivosTesoreriaBean} con el resultado de la carga.
	 */
	public ResultadoCargaArchivosTesoreriaBean validaDeRef(final DepositosRefeBean refeBean, final ResultadoCargaArchivosTesoreriaBean result,
			final int institucionID, final String accion,final long numeroTransaccion ){
		ResultadoCargaArchivosTesoreriaBean resultCarga = new ResultadoCargaArchivosTesoreriaBean();
		resultCarga = (ResultadoCargaArchivosTesoreriaBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
				new TransactionCallback<Object>() {
					public Object doInTransaction(TransactionStatus transaction) {
						try {
							MensajeTransaccionBean mensaje = null;

							/**Realiza la inserción de los datos leidos en el archivo en la tabla temporal*/
							mensaje = procesoDepositoRefereTemp(institucionID, refeBean, numeroTransaccion, accion);

							result.setNumero(mensaje.getNumero());
							result.setDescripcion(mensaje.getDescripcion());
							result.setConsecutivoInt(mensaje.getConsecutivoInt());

							/**Estas condiciones son para ir sumando el numero de exitosos y fallidos
							 * en este caso no se requieren, pero se dejo el codigoo pues no causa problemas*/
							if(mensaje.getNumero()==0){
								result.setExitosos(result.getExitosos()+1);
							}else{
								result.setFallidos(result.getFallidos()+1);
								result.setDescripcion(mensaje.getDescripcion());
							}
						} catch (Exception e) {
							e.printStackTrace();
							loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta de deposito referenciado", e);
							transaction.setRollbackOnly();
							result.setFallidos(result.getFallidos()+1);
						}
						return result;
					}
				});
		return result;
	}

	/**
	 * Aplica y registra los depósitos referenciados elegidos desde el grid.
	 * @param refeBean clase bean {@linkplain DepositosRefeBean} con los valores de entrada al SP-DEPOSITOREFEREPRO.
	 * @param numeroTransaccion número de transacción.
	 * @param accion indica si inserta o no en la tabla.
	 * @return {@linkplain MensajeTransaccionBean} con el resultado de la transacción.
	 */
	public MensajeTransaccionBean procesoDepositoRefere(final DepositosRefeBean refeBean, final long numeroTransaccion, final String accion){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
				new TransactionCallback<Object>() {
					public Object doInTransaction(TransactionStatus transaction) {
						MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
						try {
							// Query con el Store Procedure
							mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
									new CallableStatementCreator() {
										public CallableStatement createCallableStatement(Connection arg0) throws SQLException {

											String query = "call DEPOSITOREFEREPRO("
													+ "?,?,?,?,?,	"
													+ "?,?,?,?,?,	"
													+ "?,?,?,?,?,	"
													+ "?,"
													+ "?,?,?,?,?,	"
													+ "?,?,?,?,?);";
											CallableStatement sentenciaStore = arg0.prepareCall(query);

											sentenciaStore.setInt("Par_InstitucionID",Utileria.convierteEntero(refeBean.getInstitucionID()));
											sentenciaStore.setString("Par_NumCtaInstit",refeBean.getNumCtaInstit());
											sentenciaStore.setDate("Par_FechaOperacion",OperacionesFechas.conversionStrDate(refeBean.getFechaOperacion()));
											sentenciaStore.setString("Par_ReferenciaMov",refeBean.getReferenciaMov());
											sentenciaStore.setString("Par_DescripcionMov",refeBean.getDescripcionMov());

											sentenciaStore.setString("Par_NatMovimiento",refeBean.getNatMovimiento());
											sentenciaStore.setDouble("Par_MontoMov",Utileria.convierteDoble(refeBean.getMontoMov()));
											sentenciaStore.setDouble("Par_MontoPendApli",Utileria.convierteDoble(refeBean.getMontoPendApli()));
											sentenciaStore.setInt("Par_TipoCanal",Utileria.convierteEntero(refeBean.getTipoCanal()));
											sentenciaStore.setString("Par_TipoDeposito",refeBean.getTipoDeposito());

											sentenciaStore.setInt("Par_Moneda",Utileria.convierteEntero(refeBean.getTipoMoneda()));
											sentenciaStore.setString("Par_InsertaTabla",accion);// Variable para que si inserte en la tabla
											sentenciaStore.setString("Par_NumIdenArchivo", refeBean.getNumIdenArchivo());
											sentenciaStore.setString("Par_BancoEstandar", refeBean.getBancoEstandar());
											sentenciaStore.setLong("Par_Poliza",Constantes.ENTERO_CERO);

											sentenciaStore.setString("Par_Salida",Constantes.salidaSI);

											sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
											sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
											sentenciaStore.registerOutParameter("Par_Consecutivo", Types.BIGINT);
											sentenciaStore.setInt("Aud_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
											sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());

											sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
											sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
											sentenciaStore.setString("Aud_ProgramaID","DepositosRefeDAO.altaDepositosRefere");
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
												mensajeTransaccion.setConsecutivoInt(resultadosStore.getString(4));

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
							loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en proceso de deposito referencido", e);
						}
						return mensajeBean;
					}
				});
		return mensaje;
	}

	/**
	 * Lista los depósitos referenciados no identificados.
	 * @param depRefere clase bean {@linkplain DepositosRefeBean} con los valores de entrada al SP-DEPOSITOREFERECON.
	 * @param tipoConsulta número de consulta.
	 * @return Lista con los depósitos no identificados.
	 */
	public List  listaDepositosNI(DepositosRefeBean depRefere, int tipoConsulta){
		String query = "call DEPOSITOREFERECON(?,?,?,?, ?,?,?,?,?,?,?);";
		Object[] parametros = {
				Utileria.convierteEntero(depRefere.getInstitucionID()),
				depRefere.getCuentaAhoID(),
				Constantes.STRING_VACIO,
				tipoConsulta,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"CuentaNostroDAO.consultaExisteCuenta",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
		};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call DEPOSITOREFERECON(" + Arrays.toString(parametros).replace("[", "").replace("]", "") +");");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				DepositosRefeBean depRefereBean = new DepositosRefeBean();

				depRefereBean.setFolioCargaID(resultSet.getString("FolioCargaID"));
				depRefereBean.setFechaValor(resultSet.getString("FechaAplica"));
				depRefereBean.setReferenciaMov(resultSet.getString("ReferenciaMov"));
				depRefereBean.setDescripcionMov(resultSet.getString("DescripcionMov"));
				depRefereBean.setTipoCanal(resultSet.getString("TipoCanal"));
				depRefereBean.setMontoMov(resultSet.getString("MontoMov"));
				depRefereBean.setMontoPendApli(resultSet.getString("MontoPendApli"));
				depRefereBean.setTipoDeposito(resultSet.getString("TipoDeposito"));
				depRefereBean.setStatus(resultSet.getString("Status"));
				depRefereBean.setTipoMoneda(resultSet.getString("Monedaid"));
				depRefereBean.setDescrMoneda(resultSet.getString("Descripcion"));
				depRefereBean.setNatMovimiento(resultSet.getString("NatMovimiento"));

				return depRefereBean;
			}
		});
		return matches;
	}

	/**
	 * Registra los depósitos referenciados obtenidos del archivo para su posterior validación.
	 * @param institucionID ID de la institución bancaria.
	 * @param refeBean clase bean {@linkplain DepositosRefeBean} con los valores de entrada al SP-ARCHIVOCARGADEPREFALT.
	 * @param numeroTransaccion número de transacción.
	 * @param accion indica si inserta o no en la tabla.
	 * @return {@linkplain MensajeTransaccionBean} con el resultado de la transacción.
	 */
	public MensajeTransaccionBean procesoDepositoRefereTemp(final int institucionID, final DepositosRefeBean refeBean, final long numeroTransaccion, final String accion){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
				new TransactionCallback<Object>() {
					public Object doInTransaction(TransactionStatus transaction) {
						MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
						try {
							// Query con el Store Procedure
							mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
									new CallableStatementCreator() {
										public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
											String query = "call ARCHIVOCARGADEPREFALT("
													+ "?,?,?,?,?,"
													+ "?,?,?,?,?,"
													+ "?,?,?,?,?,"
													+ "?,?,?,?,?,"
													+ "?,?,?,?,"
													+ "?,?,?,?,?,?,?);";
											CallableStatement sentenciaStore = arg0.prepareCall(query);

											sentenciaStore.setInt("Par_InstitucionID",institucionID);
											sentenciaStore.setString("Par_NumCtaInstit",refeBean.getNumCtaInstit());
											sentenciaStore.setDate("Par_FechaOperacion",OperacionesFechas.conversionStrDate(refeBean.getFechaOperacion()));
											sentenciaStore.setString("Par_ReferenciaMov",refeBean.getReferenciaMov());
											sentenciaStore.setString("Par_DescripcionMov",refeBean.getDescripcionMov());

											sentenciaStore.setString("Par_NatMovimiento",refeBean.getNatMovimiento());
											sentenciaStore.setDouble("Par_MontoMov",Utileria.convierteDoble(refeBean.getMontoMov()));
											sentenciaStore.setDouble("Par_MontoPendApli",Utileria.convierteDoble(refeBean.getMontoPendApli()));
											sentenciaStore.setInt("Par_TipoCanal",Utileria.convierteEntero(refeBean.getTipoCanal()));
											sentenciaStore.setString("Par_NumIdenArchivo",refeBean.getNumIdenArchivo());

											sentenciaStore.setString("Par_TipoDeposito",refeBean.getTipoDeposito());
											sentenciaStore.setString("Par_Validacion",refeBean.getValidacion());
											sentenciaStore.setInt("Par_Moneda",Utileria.convierteEntero(refeBean.getTipoMoneda()));
											sentenciaStore.setString("Par_InsertaTabla",accion);// Variable para que si inserte en la tabla
											sentenciaStore.setInt("Par_TranAnt",Utileria.convierteEntero(refeBean.getNumTranAnt()));

											sentenciaStore.setInt("Par_NumVal",Utileria.convierteEntero(refeBean.getNumVal()));
											sentenciaStore.setString("Par_TipoMov",refeBean.getTipoMov());
											sentenciaStore.setInt("Par_NumeroFila",Utileria.convierteEntero(refeBean.getNumeroFila()));
											sentenciaStore.setString("Par_AplicarDeposito",refeBean.getAplicarDeposito());
											sentenciaStore.setString("Par_NombreArchivoCarga",refeBean.getNombreArchivoCarga());

											sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
											sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
											sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
											sentenciaStore.registerOutParameter("Par_Consecutivo", Types.BIGINT);

											sentenciaStore.setInt("Aud_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
											sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
											sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
											sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
											sentenciaStore.setString("Aud_ProgramaID"," DepositosReferenciadosDAO.procesoDepositoRefere");
											sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
											sentenciaStore.setLong("Aud_NumTransaccion",(long) numeroTransaccion);

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
												mensajeTransaccion.setConsecutivoInt(resultadosStore.getString("Consecutivo"));

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
							if (mensajeBean.getNumero() == 999) {
								mensajeBean.setDescripcion("Ocurrió un Error, Verifique que el Archivo sea el Correcto");
								mensajeBean.getDescripcion();
							}

							mensajeBean.setDescripcion(e.getMessage());
							transaction.setRollbackOnly();
							e.printStackTrace();
							loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en proceso de deposito referencido", e);
						}
						return mensajeBean;
					}
				});
		return mensaje;
	}

	/**
	 * Lista los depósitos referenciados del archivo cargado.
	 * @param depRefere clase bean {@linkplain DepositosRefeBean} con los valores de entrada al SP-ARCHIVOCARGADEPREFLIS.
	 * @param tipoLista número de lista.
	 * @return lista de los depósitos cargados recientemente.
	 */
	public List listaDepositosReferenciados(DepositosRefeBean depRefere, int tipoLista){
		String query = "call ARCHIVOCARGADEPREFLIS(?,?,?,?,	?,?,?,?,?,?,?);";
		Object[] parametros = {
				Utileria.convierteEntero(depRefere.getInstitucionID()),
				depRefere.getCuentaAhoID(),
				depRefere.getNumTransaccion(),
				tipoLista,

				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				parametrosAuditoriaBean.getNombrePrograma(),
				parametrosAuditoriaBean.getSucursal(),
				Constantes.ENTERO_CERO
		};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call ARCHIVOCARGADEPREFLIS(" + Arrays.toString(parametros).replace("[", "").replace("]", "") +");");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				DepositosRefeBean depRefereBean = new DepositosRefeBean();
				depRefereBean.setFolioCargaID(resultSet.getString("FolioCargaID"));
				depRefereBean.setNumCtaInstit(resultSet.getString("CuentaAhoID"));
				depRefereBean.setFechaOperacion(resultSet.getString("FechaAplica"));
				depRefereBean.setReferenciaMov(resultSet.getString("ReferenciaMov"));
				depRefereBean.setMontoMov(resultSet.getString("MontoMov"));
				depRefereBean.setNatMovimiento(resultSet.getString("NatMovimiento"));
				depRefereBean.setDescripcionMov(resultSet.getString("DescripcionMov"));
				depRefereBean.setTipoMov(resultSet.getString("TipoMov"));
				depRefereBean.setTipoDeposito(resultSet.getString("TipoDeposito"));
				depRefereBean.setTipoMoneda(resultSet.getString("MonedaID"));
				depRefereBean.setTipoCanal(resultSet.getString("TipoCanal"));
				depRefereBean.setNumIdenArchivo(resultSet.getString("NumIdenArchivo"));
				depRefereBean.setNumTransaccion(resultSet.getString("NumTransaccion"));
				depRefereBean.setValidacion(resultSet.getString("Validacion"));
				depRefereBean.setNumVal(resultSet.getString("NumVal"));
				depRefereBean.setNumTran(resultSet.getString("NumTran"));
				return depRefereBean;
			}
		});
		return matches;
	}
	/**
	 * Consulta las validaciones del archivo de carga para depósitos referenciados.
	 * @param depRefere clase bean con los valores de entrada a SP-ARCHIVOCARGADEPREFCON.
	 * @param tipoConsulta número de consulta.
	 * @return {@linkplain DepositosRefeBean} con el resultado de la transacción.
	 */
	public DepositosRefeBean Validaciones(DepositosRefeBean depRefere, int tipoConsulta){
		String query = "call ARCHIVOCARGADEPREFCON(?,?,?,?,?, ?,?,?,?,?,?);";
		Object[] parametros = {
				Utileria.convierteEntero(depRefere.getInstitucionID()),
				Utileria.convierteLong(depRefere.getNumCtaInstit()),
				depRefere.getNumTransaccion(),
				tipoConsulta,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"CuentaNostroDAO.consultaValidacionesDepositos",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
		};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call ARCHIVOCARGADEPREFCON(" + Arrays.toString(parametros).replace("[", "").replace("]", "") +");");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				DepositosRefeBean depRefereBean = new DepositosRefeBean();
				depRefereBean.setValidacion(resultSet.getString("Validaciones"));
				return depRefereBean;
			}
		});
		return matches.size() > 0 ? (DepositosRefeBean) matches.get(0) : null;
	}

	/**
	 * Consulta el número de validaciones realizadas.
	 * @param depRefere clase bean {@linkplain DepositosRefeBean} con los valores a SP-DEPOSITOREFERECON.
	 * @param tipoConsulta número de consulta.
	 * @return {@linkplain DepositosRefeBean} con el resultado de la consulta.
	 */
	public DepositosRefeBean ValNumIdArch(DepositosRefeBean depRefere, int tipoConsulta){
		String query = "call DEPOSITOREFERECON(?,?,?,?, ?,?,?,?,?,?,?);";
		Object[] parametros = {
				Constantes.ENTERO_CERO,
				Constantes.STRING_VACIO,
				depRefere.getNumIdenArchivo(),
				tipoConsulta,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"CuentaNostroDAO.consultaValidacionesDepositos",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
		};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call DEPOSITOREFERECON(" + Arrays.toString(parametros).replace("[", "").replace("]", "") +");");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				DepositosRefeBean depRefereBean = new DepositosRefeBean();
				depRefereBean.setNumReg(Utileria.convierteEntero(resultSet.getString("NumReg")));
				return depRefereBean;
			}
		});
		return matches.size() > 0 ? (DepositosRefeBean) matches.get(0) : null;
	}

	/**
	 * Validación del mensaje de la cuenta de ahorro en la tabla temporal.
	 * @param depRefere clase bean {@linkplain DepositosRefeBean} con los valores de entrada al SP-ARCHIVOCARGADEPREFVAL.
	 * @return {@linkplain MensajeTransaccionBean} con el resultado de la transacción.
	 */
	public MensajeTransaccionBean validaMensajeValTablaTmp(final DepositosRefeBean depRefere) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call ARCHIVOCARGADEPREFVAL("
											+ "?,?,?,?,?,	"
											+ "?,?,?,?,?,	"
											+ "?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);

									sentenciaStore.setInt("Par_InstitucionID",Utileria.convierteEntero(depRefere.getInstitucionID()));
									sentenciaStore.setString("Par_ReferenciaMov",depRefere.getReferenciaMov());
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
								public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,DataAccessException {

									MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
									if(callableStatement.execute()){
										ResultSet resultadosStore = callableStatement.getResultSet();
										resultadosStore.next();
										mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString("NumErr")).intValue());
										mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
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
					}
				} catch (Exception e) {
					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en la Validación del Mensaje de la Tabla Temporal", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	/**
	 * Limpia los registros cargados recientemente para la nueva carga del archivo de depósitos referenciados.
	 * @param numTransCarg número de transacción de la carga del archivo realizada.
	 * @return {@linkplain MensajeTransaccionBean} con el resutado de la transacción.
	 */
	public MensajeTransaccionBean borraDatosTablaTmp(final String numTransCarg){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
				new TransactionCallback<Object>() {
					public Object doInTransaction(TransactionStatus transaction) {
						MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
						try {
							// Query con el Store Procedure
							mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
									new CallableStatementCreator() {
										public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
											String query = "call ARCHIVOCARGADEPREFBAJ("
													+ "?,?,?,?,?,"
													+ "?,?,?,?,?,"
													+ "?,?,?);";
											CallableStatement sentenciaStore = arg0.prepareCall(query);

											sentenciaStore.setInt("Par_TranCarga",Utileria.convierteEntero(numTransCarg));
											sentenciaStore.setInt("Par_TipoBaja",1);
											sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
											sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
											sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

											sentenciaStore.registerOutParameter("Par_Consecutivo", Types.BIGINT);
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
										public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,
										DataAccessException {
											MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
											if(callableStatement.execute()){
												ResultSet resultadosStore = callableStatement.getResultSet();
												resultadosStore.next();
												mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString("NumErr")).intValue());
												mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));

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
							if (mensajeBean.getNumero() == 999) {
								mensajeBean.setDescripcion("Ocurrió un Error en Eliminación Tabla Temporal");
								mensajeBean.getDescripcion();
							}

							mensajeBean.setDescripcion(e.getMessage());
							transaction.setRollbackOnly();
							e.printStackTrace();
							loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Proceso de Eliminación Tabla Temporal", e);
						}
						return mensajeBean;
					}
				});
		return mensaje;
	}




	/**
	 * @author lvicente
	 * @param depRefere
	 * @param tipoConsulta
	 * @return
	 */
	public CatCodigoLeyendaBean consultaCodigoLeyenda(CatCodigoLeyendaBean catCodigoLeyendaBean, int tipoConsulta){
		String query = "call CATCODIGOLEYENDACON(?,?,?,?, ?,?,?,?,?,?,?);";
		Object[] parametros = {
				catCodigoLeyendaBean.getCodigoLeyenda(),
				catCodigoLeyendaBean.getTipoDeposito(),
				tipoConsulta,
				Constantes.STRING_VACIO,
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"DepositosRefeDAO.ConsultaCodigoLeyenda",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
		};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CATCODLEYENDACON(" + Arrays.toString(parametros).replace("[", "").replace("]", "") +");");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				CatCodigoLeyendaBean conCatCodigoLeyendaBean = new CatCodigoLeyendaBean();
				conCatCodigoLeyendaBean.setCodigoLeyenda(resultSet.getString("CodigoLeyenda"));
				conCatCodigoLeyendaBean.setIdentificador(resultSet.getString("Identificador"));
				conCatCodigoLeyendaBean.setDescripcion(resultSet.getString("Descripcion"));
				conCatCodigoLeyendaBean.setTipoDeposito(resultSet.getString("TipoDeposito"));
				return conCatCodigoLeyendaBean;
			}
		});
		return matches.size() > 0 ? (CatCodigoLeyendaBean) matches.get(0) : null;
	}





	public ResultadoCargaArchivosTesoreriaBean cargaArchivoBanamex(final String rutaArchivo,final DepositosRefeBean depositosRefeBean){
		ResultadoCargaArchivosTesoreriaBean resultado = new ResultadoCargaArchivosTesoreriaBean();

		resultado = (ResultadoCargaArchivosTesoreriaBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
				new TransactionCallback<Object>() {
					public Object doInTransaction(TransactionStatus transaction) {
						ResultadoCargaArchivosTesoreriaBean resultadoCarga =new ResultadoCargaArchivosTesoreriaBean();
						List<DepositosRefeBean> depositoReferenciado = null;
						int tamanoLista= 0;
						Iterator<DepositosRefeBean> iterList = null;
						DepositosRefeBean refeBean = new DepositosRefeBean();
						String motivoExclusion = saltoLinea + "Archivo cargado Exitosamente.";

						/**Cuando el usuario carga o vuelve a cargar el archivo se borran de la tabla temporal
						 * los datos que se cargaron anteriormente, por numero de transaccion.*/
						String numTrantmp = depositosRefeBean.getNumTranAnt();
						MensajeTransaccionBean mensajeBorraTmp = new MensajeTransaccionBean();
						int intitucionID = Utileria.convierteEntero(depositosRefeBean.getInstitucionID());

						try{
							depositoReferenciado = leeArchivoBanamex(depositosRefeBean, rutaArchivo);
							if(depositoReferenciado!=null){
								iterList = depositoReferenciado.iterator();
								tamanoLista= depositoReferenciado.size();
								long numeroTransaccion = transaccionDAO.generaNumeroTransaccionOut();
								if(tamanoLista > 0){
									while(iterList.hasNext()){

										refeBean = iterList.next();
										String fechaOperacion;
										String naturalezaOperacion;
										String numeroOperacion;
										String referenciaBancaria;
										String monto;
										String numIdArchivo;

										naturalezaOperacion = refeBean.getNatMovimiento();
										numeroOperacion = refeBean.getTipoMov();
										referenciaBancaria = refeBean.getReferenciaMov();
										monto = refeBean.getMontoMov();
										fechaOperacion = refeBean.getFechaOperacion();
										numIdArchivo = refeBean.getNumIdenArchivo();

										refeBean.setTipoCanal(depositosRefeBean.getTipoCanal());
										refeBean.setNumTranAnt(depositosRefeBean.getNumTranAnt());
										refeBean.setFechaOperacion(fechaOperacion);
										refeBean.setDescripcionMov("DEPOSITO REFERENCIADO");
										refeBean.setMontoMov(monto);
										refeBean.setNumIdenArchivo(numIdArchivo);

										if (refeBean.getTipoMov().equals("11")) {
											refeBean.setTipoDeposito("E");
										} else if (refeBean.getTipoMov().equals("13")|| refeBean.getTipoMov().equals("15")){
											refeBean.setTipoDeposito("C");
										} else if (refeBean.getTipoMov().equals("17")) {
											refeBean.setTipoDeposito("T");
										}
										refeBean.setReferenciaMov(referenciaBancaria);
										refeBean.setTipoMoneda("1");
										refeBean.setNumCtaInstit(depositosRefeBean.getNumCtaInstit());
										refeBean.setInstitucionID(depositosRefeBean.getInstitucionID());

										MensajeTransaccionBean mensaje = new MensajeTransaccionBean(); /**Mensaje transaccion*/

										/**Si la validacion de el limite de saldo excedido se repite en algun registro
										 * solo se activara el primer registro que se obtenga en el la tabla tmp para aplicarlo**/
										mensaje = validaMensajeValTablaTmp(refeBean);

										if (mensaje.getNumero() == 10) {
											refeBean.setNumVal("15");
										}
										/**Aqui se va a guardar en una tabla temporal **/
										resultadoCarga = validaDeRef(refeBean, resultadoCarga,intitucionID,Enum_Tra_Inserta.grabaTabla,numeroTransaccion);

										/**la suma de los exitos se hace dentro de la alta de depositos
										 * altaDepositosRefere, pero esto ya no se requiere en la pantalla**/
										if (resultadoCarga.getNumero() != 0) {
											resultadoCarga.setDescripcion(resultadoCarga.getDescripcion()+ saltoLinea
													+ "Intente cargar de nuevo el archivo.");
											throw new Exception(resultadoCarga.getDescripcion());
										}
										resultadoCarga.setDescripcion("Total Registros: "+ tamanoLista+ motivoExclusion);
									}
								}else{
									resultadoCarga.setDescripcion("Asegurese de subir el archivo con el formato correcto.");
									throw new Exception(resultadoCarga.getDescripcion());
								}
							}else{
								resultadoCarga.setDescripcion("Asegurese de subir el archivo con el formato correcto.");
								throw new Exception(resultadoCarga.getDescripcion());
							}
						}
						catch(Exception e){
							e.printStackTrace();
							loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en carga de archivo", e);
							resultadoCarga.setNumero(999);

							if(tamanoLista <= 0){
								resultadoCarga.setDescripcion("Asegurese de subir el archivo con el formato correcto.");
							}
							resultadoCarga.setDescripcion("Asegurese de subir el archivo con el formato correcto.");
							transaction.setRollbackOnly();
						}
						return resultadoCarga;

					}
				});
		return resultado;
	}
	public ResultadoCargaArchivosTesoreriaBean cargaArchivoBanorte(final String rutaArchivo,final DepositosRefeBean depositosRefeBean){
		ResultadoCargaArchivosTesoreriaBean resultado = new ResultadoCargaArchivosTesoreriaBean();

		resultado = (ResultadoCargaArchivosTesoreriaBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
				new TransactionCallback<Object>() {
					public Object doInTransaction(TransactionStatus transaction) {

						ResultadoCargaArchivosTesoreriaBean resultadoCarga =new ResultadoCargaArchivosTesoreriaBean();

						final long numeroTransaccion = transaccionDAO.generaNumeroTransaccionOut();
						List<DepositosRefeBean> depositoReferenciado = null;
						int tamanoLista= 0;
						Iterator<DepositosRefeBean> iterList = null;
						DepositosRefeBean refeBean = new DepositosRefeBean();
						String motivoExclusion = saltoLinea+ "Archivo Cargado Exitosamente.";

						/**Cuando el usuario carga o vuelve a cargar el archivo se borran de la tabla temporal
						 * los datos que se cargaron anteriormente, por numero de transaccion*/
						String numTrantmp = depositosRefeBean.getNumTranAnt();
						MensajeTransaccionBean mensajeBorraTmp = new MensajeTransaccionBean();
						mensajeBorraTmp = borraDatosTablaTmp(numTrantmp);

						int intitucionID = Integer.parseInt(depositosRefeBean.getInstitucionID());
						try{
							depositoReferenciado =  leeArchivoBanorte(depositosRefeBean, rutaArchivo);
							if(depositoReferenciado!=null){
								iterList = depositoReferenciado.iterator();
								tamanoLista= depositoReferenciado.size();
								if(tamanoLista > 0){
									while(iterList.hasNext()){
										refeBean = iterList.next();
										refeBean.setNumTranAnt(depositosRefeBean.getNumTranAnt());
										refeBean.setTipoMoneda("1");//tipo moneda solo para el movimiento 15 esta quemado en la pantalla con valor de "1"
										refeBean.setNumCtaInstit(depositosRefeBean.getNumCtaInstit());
										refeBean.setTipoCanal(depositosRefeBean.getTipoCanal());//tipo canal obtenido

										try{// segun el tipo de canal la descripción de movimiento
											switch(Integer.valueOf(depositosRefeBean.getTipoCanal())){
											case 1:	refeBean.setDescripcionMov("DEPOSITO REFERENCIADO POR PAGO DE CREDITO"); break;
											case 2:	refeBean.setDescripcionMov("DEPOSITO REFERENCIADO POR ABONO A CUENTA"); break;
											case 3:	refeBean.setDescripcionMov("DEPOSITO REFERENCIADO POR DEPOSITO A CLIENTE"); break;
											default: refeBean.setDescripcionMov("DEPOSITO REFERENCIADO");
											}
										}catch(Exception e){
											refeBean.setDescripcionMov("DEPOSITO REFERENCIADO");
										}
										refeBean.setInstitucionID(depositosRefeBean.getInstitucionID());

										/**Si la validacion de el limite de saldo excedido se repite en algun registro
										 * solo se activara el primer registro que se obtenga en el la tabla tmp para aplicarlo**/
										MensajeTransaccionBean mensaje=new MensajeTransaccionBean();
										mensaje= validaMensajeValTablaTmp(refeBean);

										if(mensaje.getNumero()==10){
											refeBean.setNumVal("15");
										}

										resultadoCarga =  validaDeRef(refeBean, resultadoCarga, intitucionID, Enum_Tra_Inserta.grabaTabla,numeroTransaccion);

										if(resultadoCarga.getNumero() != 0){
											resultadoCarga.setDescripcion(resultadoCarga.getDescripcion()+saltoLinea+"Intente cargar de nuevo el archivo.");
											throw new Exception(resultadoCarga.getDescripcion());
										}
										resultadoCarga.setDescripcion("Total Registros: "+ tamanoLista + motivoExclusion);
									}
								}else{
									resultadoCarga.setDescripcion("Asegurese de subir el archivo con el formato correcto.");
									throw new Exception(resultadoCarga.getDescripcion());
								}
							}else{
								resultadoCarga.setDescripcion("Asegurese de subir el archivo con el formato correcto.");
								throw new Exception(resultadoCarga.getDescripcion());
							}
						}
						catch(Exception e){
							e.printStackTrace();
							loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en carga de archivo", e);
							resultadoCarga.setNumero(999);

							if(tamanoLista <= 0){
								resultadoCarga.setDescripcion("Asegurese de subir el archivo con el formato correcto.");
							}
							resultadoCarga.setDescripcion("Asegurese de subir el archivo con el formato correcto.");
							transaction.setRollbackOnly();
						}
						return resultadoCarga;
					}
				});
		return resultado;
	}


	public ResultadoCargaArchivosTesoreriaBean cargaArchivoBancomer(final String rutaArchivo, final DepositosRefeBean depositosRefeBean){
		ResultadoCargaArchivosTesoreriaBean resultado = new ResultadoCargaArchivosTesoreriaBean();
		resultado = (ResultadoCargaArchivosTesoreriaBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
				new TransactionCallback<Object>() {
					public Object doInTransaction(TransactionStatus transaction) {

						ResultadoCargaArchivosTesoreriaBean resultadoCarga =new ResultadoCargaArchivosTesoreriaBean();

						final long numeroTransaccion = transaccionDAO.generaNumeroTransaccionOut();
						List<DepositosRefeBean> depositoReferenciado = null;
						int tamanoLista= 0;
						Iterator<DepositosRefeBean> iterList = null;
						DepositosRefeBean refeBean = new DepositosRefeBean();
						String motivoExclusion = saltoLinea+ "Archivo Cargado Exitosamente.";

						/**Cuando el usuario carga o vuelve a cargar el archivo se borran de la tabla temporal
						 * los datos que se cargaron anteriormente, por numero de transaccion*/
						String numTrantmp = depositosRefeBean.getNumTranAnt();
						MensajeTransaccionBean mensajeBorraTmp = new MensajeTransaccionBean();
						mensajeBorraTmp = borraDatosTablaTmp(numTrantmp);

						int intitucionID = Integer.parseInt(depositosRefeBean.getInstitucionID());
						try{
							depositoReferenciado = leerArchivoBancomer(depositosRefeBean, rutaArchivo);
							if(depositoReferenciado!=null){
								tamanoLista= depositoReferenciado.size();

								 iterList = depositoReferenciado.iterator();


								if(depositoReferenciado!=null && depositoReferenciado.size() > 0){
									while(iterList.hasNext()){
										refeBean = (DepositosRefeBean) iterList.next();
										refeBean.setNumTranAnt(depositosRefeBean.getNumTranAnt());
										refeBean.setNumCtaInstit(depositosRefeBean.getNumCtaInstit());
										refeBean.setInstitucionID(depositosRefeBean.getInstitucionID());
										MensajeTransaccionBean mensaje=new MensajeTransaccionBean();
										mensaje = validaMensajeValTablaTmp(refeBean);
										refeBean.setTipoMoneda("1");
										//refeBean.setTipoCanal(depositosRefeBean.getTipoCanal());
										if(mensaje.getNumero()==10){
											refeBean.setNumVal("15");
										}

										resultadoCarga = validaDeRef(refeBean, resultadoCarga, intitucionID, Enum_Tra_Inserta.grabaTabla,numeroTransaccion);

										if(resultadoCarga.getNumero()!=0){
											throw new Exception(resultadoCarga.getDescripcion());
										}
										resultadoCarga.setDescripcion("Total Registros:"+tamanoLista+motivoExclusion);
									}
								}else{
								resultadoCarga.setNumero(999);
								resultadoCarga.setDescripcion("Asegurese de subir el archivo con el formato correcto.");
								throw new Exception(resultadoCarga.getDescripcion());
								}
							}else{
								resultadoCarga.setDescripcion("Asegurese de subir el archivo con el formato correcto.");
								throw new Exception(resultadoCarga.getDescripcion());
							}
						}
						catch(Exception e){
							e.printStackTrace();
							loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en carga de archivo", e);
							resultadoCarga.setNumero(999);

							if(tamanoLista <= 0){
								resultadoCarga.setDescripcion("Asegurese de subir el archivo con el formato correcto.");
							}
							resultadoCarga.setDescripcion("Asegurese de subir el archivo con el formato correcto.");
							transaction.setRollbackOnly();
						}
						return resultadoCarga;

					}
				});
		return resultado;
	}

	/**
	 * Metodo para cargar un archivo de la institución Bancomer utilizando el algoritmo 36
	 * Algoritmo Bancomer 36  (1 Dígito Verificador)
	 * @param rutaArchivo
	 * @param depositosRefeBean
	 * @return depositosRefeDAO
	 */
	public ResultadoCargaArchivosTesoreriaBean cargaArchivoBancomerALG36(final String rutaArchivo, final DepositosRefeBean depositosRefeBean){
		ResultadoCargaArchivosTesoreriaBean resultado = new ResultadoCargaArchivosTesoreriaBean();
		resultado = (ResultadoCargaArchivosTesoreriaBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
				new TransactionCallback<Object>() {
					public Object doInTransaction(TransactionStatus transaction) {

						ResultadoCargaArchivosTesoreriaBean resultadoCarga = new ResultadoCargaArchivosTesoreriaBean();

						final long numeroTransaccion = transaccionDAO.generaNumeroTransaccionOut();
						List<DepositosRefeBean> depositoReferenciado = null;
						int tamanoLista = 0;
						Iterator<DepositosRefeBean> iterList = null;
						DepositosRefeBean refeBean = new DepositosRefeBean();
						String motivoExclusion = saltoLinea + "Archivo Cargado Exitosamente.";

						/**Cuando el usuario carga o vuelve a cargar el archivo se borran de la tabla temporal
						 * los datos que se cargaron anteriormente, por numero de transaccion*/
						String numTrantmp = depositosRefeBean.getNumTranAnt();
						MensajeTransaccionBean mensajeBorraTmp = new MensajeTransaccionBean();
						mensajeBorraTmp = borraDatosTablaTmp( numTrantmp );

						int intitucionID = Integer.parseInt( depositosRefeBean.getInstitucionID() );

						try{
							depositoReferenciado = leerArchivoBancomerALG36( depositosRefeBean, rutaArchivo );

							if( depositoReferenciado != null ) {

								tamanoLista = depositoReferenciado.size();
								iterList = depositoReferenciado.iterator();

								if( depositoReferenciado != null && depositoReferenciado.size() > 0 ) {

									while(iterList.hasNext()){
										refeBean = (DepositosRefeBean) iterList.next();
										refeBean.setNumTranAnt(depositosRefeBean.getNumTranAnt());
										refeBean.setNumCtaInstit(depositosRefeBean.getNumCtaInstit());
										refeBean.setInstitucionID(depositosRefeBean.getInstitucionID());
										MensajeTransaccionBean mensaje=new MensajeTransaccionBean();
										mensaje = validaMensajeValTablaTmp(refeBean);
										refeBean.setTipoMoneda("1");
										if(mensaje.getNumero()==10){
											refeBean.setNumVal("15");
										}

										resultadoCarga = validaDeRef(refeBean, resultadoCarga, intitucionID, Enum_Tra_Inserta.grabaTabla,numeroTransaccion);

										if(resultadoCarga.getNumero()!=0){
											throw new Exception(resultadoCarga.getDescripcion());
										}
										resultadoCarga.setDescripcion("Total Registros:"+tamanoLista+motivoExclusion);
									}
								}else{
								resultadoCarga.setNumero(999);
								resultadoCarga.setDescripcion("Asegurese de subir el archivo con el formato correcto.");
								throw new Exception(resultadoCarga.getDescripcion());
								}
							}else{
								resultadoCarga.setDescripcion("Asegurese de subir el archivo con el formato correcto.");
								throw new Exception(resultadoCarga.getDescripcion());
							}
						}
						catch(Exception e){
							e.printStackTrace();
							loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en carga de archivo", e);
							resultadoCarga.setNumero(999);

							if(tamanoLista <= 0){
								resultadoCarga.setDescripcion("Asegurese de subir el archivo con el formato correcto.");
							}
							resultadoCarga.setDescripcion("Asegurese de subir el archivo con el formato correcto.");
							transaction.setRollbackOnly();
						}
						return resultadoCarga;

					}
				});
		return resultado;
	}

	/*METODO PARA CARGA DEL ARCHIVO ESTANDAR*/
	public ResultadoCargaArchivosTesoreriaBean cargaArchivo(final String rutaArchivo, final DepositosRefeBean depositosRefeBean){
		ResultadoCargaArchivosTesoreriaBean resultado = new ResultadoCargaArchivosTesoreriaBean();

		resultado = (ResultadoCargaArchivosTesoreriaBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
				new TransactionCallback<Object>() {
					public Object doInTransaction(TransactionStatus transaction) {
						ResultadoCargaArchivosTesoreriaBean resultadoCarga =new ResultadoCargaArchivosTesoreriaBean();
						int tamanoLista=0;
						String motivoDescripcion = saltoLinea + "Archivo cargado exitosamente.";
						try{

							/**Cuando el usuario carga o vuelve a cargar el archivo se borran de la tabla temporal
							 * los datos que se cargaron anteriormente, por numero de transaccion*/
							String numTrantmp = depositosRefeBean.getNumTranAnt();
							MensajeTransaccionBean mensajeBorraTmp = new MensajeTransaccionBean();
							mensajeBorraTmp = borraDatosTablaTmp(numTrantmp);
							List <DepositosRefeBean> depositoReferenciado;

							depositoReferenciado = leeArchivo(depositosRefeBean, rutaArchivo);

							if(depositoReferenciado!=null){
								tamanoLista= depositoReferenciado.size();

								Iterator <DepositosRefeBean> iterList = depositoReferenciado.iterator();
								int intitucionID = Utileria.convierteEntero(depositosRefeBean.getInstitucionID());

								DepositosRefeBean refeBean;
								if(depositoReferenciado!=null && depositoReferenciado.size() > 0){
									long numeroTransaccion = transaccionDAO.generaNumeroTransaccionOut();
									while(iterList.hasNext()){

										refeBean = (DepositosRefeBean) iterList.next();
										refeBean.setNumTranAnt(depositosRefeBean.getNumTranAnt());
										refeBean.setNumCtaInstit(depositosRefeBean.getNumCtaInstit());

										refeBean.setInstitucionID(depositosRefeBean.getInstitucionID());
										MensajeTransaccionBean mensaje=new MensajeTransaccionBean();
										mensaje = validaMensajeValTablaTmp(refeBean);
										refeBean.setTipoMoneda("1");

										if(mensaje.getNumero()==10){
											refeBean.setNumVal("15");
										}

										resultadoCarga = validaDeRef(refeBean, resultadoCarga, intitucionID, Enum_Tra_Inserta.grabaTabla,numeroTransaccion);

										if(resultadoCarga.getNumero()!=0){
											throw new Exception(resultadoCarga.getDescripcion());
										}
										resultadoCarga.setDescripcion("Total Registros:"+tamanoLista+motivoDescripcion);
									}
								}else{
									resultadoCarga.setNumero(999);
									resultadoCarga.setDescripcion("Asegurese de subir el archivo con el formato correcto.");
									throw new Exception(resultadoCarga.getDescripcion());
								}
							}else{
								resultadoCarga.setDescripcion("Asegurese de subir el archivo con el formato correcto.");
								throw new Exception(resultadoCarga.getDescripcion());
							}
						}catch(Exception e){
							e.printStackTrace();
							loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en carga de archivo", e);
							resultadoCarga.setConsecutivoInt("institucionID");
							resultadoCarga.setConsecutivoString("institucionID");
							resultadoCarga.setNumero(999);

							if(tamanoLista <= 0){
								resultadoCarga.setDescripcion("Asegúrese de subir el archivo con el formato correcto.");
							}
							resultadoCarga.setDescripcion("Asegúrese de subir el archivo con el formato correcto.");
							transaction.setRollbackOnly();
						}
						return resultadoCarga;
					}
				});
		return resultado;
	}

	/**
	 * Aplicación de los depósitos referenciados seleccionados en el grid.
	 * @param depositosRefeBean
	 * @param pagosLista lista con los depósitos por aplicar.
	 * @param accion
	 * @return
	 */
	public MensajeTransaccionBean aplicaPagosRef(final DepositosRefeBean depositosRefBean, final List pagosLista, final String accion, final String formatoBanco) {
		/**Se genera el número de transacción**/
		long numeroTransaccion = transaccionDAO.generaNumeroTransaccionOut();
		String numTrantmp = "0";
		int institucionID = Utileria.convierteEntero(depositosRefBean.getInstitucionID());

		MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
		DepositosRefeBean depositosRefe = new DepositosRefeBean();

		try {
			for(int i=0; i<pagosLista.size(); i++){

				depositosRefe = (DepositosRefeBean)pagosLista.get(i);

				/**Se genera la fecha de operación del deposito referenciado**/
				String fechaInc=depositosRefe.getFechaOperacion();
				String  anio=fechaInc.substring(0,4);
				String  mes=fechaInc.substring(4,6);
				String  dia=fechaInc.substring(6,8);
				String  fechaCorrec=anio+"-"+mes+"-"+dia;
				depositosRefe.setFechaOperacion(fechaCorrec);
				depositosRefe.setInstitucionID(depositosRefBean.getInstitucionID());
				depositosRefe.setBancoEstandar(depositosRefBean.getBancoEstandar());


				/**Se setea el numero de movimiento**/
				depositosRefe.setNumeroMov(depositosRefe.getTipoMov());

				/**Si el deposito es de tipo canal 2 (Cuenta) entonces el proceso entra
				 * aqui para aplicar el deposito referenciado**/
				if(depositosRefe.getTipoCanal().equals("2")){
					mensajeBean=aplicaDepositosCuentaAho(depositosRefe,accion,numeroTransaccion);
					if (mensajeBean.getNumero() != 0) {
						throw new Exception(mensajeBean.getDescripcion());
					}
					mensajeBean.setDescripcion(mensajeBean.getDescripcion());
				}else{
					mensajeBean = procesoDepositoRefere(depositosRefe,numeroTransaccion,accion);
					if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
					mensajeBean.setDescripcion(mensajeBean.getDescripcion());
				}
				if (mensajeBean.getNumero() != 0) {
					throw new Exception(mensajeBean.getDescripcion());
				}else {
					mensajeBean.setNumero(0);
					mensajeBean.setDescripcion(mensajeBean.getDescripcion());
				}
				numTrantmp=depositosRefe.getNumTransaccion();
			}
			/** Una vez que se haya insertado todos los depositos se
			 * borra los datos de la tabla temporal**/
			MensajeTransaccionBean mensajeBorraTmp=new MensajeTransaccionBean();

		} catch (Exception e) {
			if(mensajeBean.getNumero()==0){
				mensajeBean.setNumero(999);
			}
			mensajeBean.setDescripcion(e.getMessage());
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error al realizar la operacion", e);
		}

		return mensajeBean;
	}

	public MensajeTransaccionBean aplicaDepositosCuentaAho(final DepositosRefeBean depositosRefe, final String accion, final long numeroTransaccion){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean)transactionTemplate.execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean =new MensajeTransaccionBean();

				int numVal=Utileria.convierteEntero(depositosRefe.getNumVal());
				int numMov=Utileria.convierteEntero(depositosRefe.getNumeroMov());
				try{
					if (numVal == 3 || numVal == 4) {
						/**Si el numero de validación obtenido en el grid es 3 o 4, es por que el saldo de la cuenta
						 * excedio su limite de saldo en el mes o excedio su limite de saldo en general
						 * en este caso el deposito se aplica, pero se da de alta como cuenta con limite de saldo excedido**/
						mensajeBean = procesoDepositoRefere(depositosRefe,numeroTransaccion,Enum_Tra_Inserta.grabaTabla);

						if (mensajeBean.getNumero() != 0) {
							throw new Exception(mensajeBean.getDescripcion());
						}

						/** Se inserta en limexctas**/
						MensajeTransaccionBean mensajeLimExCue=new MensajeTransaccionBean();
						CuentasAhoBean cuentaAhoBean = new CuentasAhoBean();
						cuentaAhoBean.setCuentaAhoID(depositosRefe.getReferenciaMov());
						cuentaAhoBean.setCanal("R");
						cuentaAhoBean.setMotivoLimite(numVal);
						cuentaAhoBean.setDescripcionLimite(depositosRefe.getValidacion());
						cuentaAhoBean.setFechaMovimento(depositosRefe.getFechaOperacion());
						mensajeLimExCue = cuentasAhoDAO.altaLimExCuentas(cuentaAhoBean, false);
						if (mensajeBean.getNumero() != 0) {
							throw new Exception(mensajeBean.getDescripcion());
						}
					} else {
						if (numVal == 0) {
							/**Si el numero de validación obtenido en el grid es igual con 0
							 * entonces el deposito se aplica normalmente**/
							mensajeBean = procesoDepositoRefere(depositosRefe,numeroTransaccion,Enum_Tra_Inserta.grabaTabla);
							if (mensajeBean.getNumero() != 0) {
								throw new Exception(mensajeBean.getDescripcion());
							}
						}
					}
				}catch(Exception e){
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en Aplicación de Depositos Referenciados", e);
					mensajeBean.setNumero(999);
					transaction.setRollbackOnly();
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	public List<DepositosRefeBean> leeArchivoBanamex(DepositosRefeBean depositosRefeBean, String rutaArchivo){
		ArrayList<DepositosRefeBean> listaDep = new ArrayList<DepositosRefeBean>();
		BufferedReader bufferedReader;
		String [] arreglo = null;

		int numeroLinea =0;
		DepositosRefeBean depRefe;
		String renglon;

		int tamEncabezado = 6;
		int tamReferencia = 38;/**35 que pide el store y los 3 caracteres: de la K y 2 numeros al final**/
		int numCamposEncabezado = 10;

		/**Para validacion de la referencia**/
		int verificador =0; /**se obtiene de la referencia que contiene el archivo**/
		String referenciaval=""; /**guarda el numero verificador que le corresponde a la referencia (Algoritmo modulo 97)**/
		int numVerificador=0; /**se obtiene de la validacion**/

		/**Encabezados**/
		String fechaOperacion	="";
		String [] auxFecha		=null;
		String naturaleza		="";
		String tipoOperacion	="";
		String referencia		="";
		String monto			="";
		String numIdArchivo		="";
		String fechaNumId		="";
		String NumTransa		= "";

		int numFila = 0;

		try {
			bufferedReader = new BufferedReader(new FileReader(rutaArchivo));

			while ((renglon = bufferedReader.readLine())!= null){
				numeroLinea +=1;
				if(tamEncabezado<numeroLinea&& !renglon.trim().equals("") ){
					depRefe = new DepositosRefeBean();
					arreglo = renglon.split("\\|");
					depRefe.setNumError("0");
					depRefe.setNumCtaInstit(arreglo[0].trim());

					numFila++;
					depRefe.setNumeroFila(""+numFila);
					depRefe.setAplicarDeposito("N");
					depRefe.setNombreArchivoCarga(rutaArchivo);
					if(arreglo.length==numCamposEncabezado ){
						/**0002/MDAD
						 *
						 * type='';type=new Array();type['A']='Abono';type['C']='Cargo';
						 * EOC
						 * codecat='';codecat=new Array();codecat['3']='type';
						 * 23/10/2013|11:51|98265702|KU BO FINANCIERO SAPI DE CV SOFOM EN|01|VICENTE,FENOLL/A|22/10/13|7004|7279273|KU BO FINANCIERO SAPI DE C|+|59,422.00|+|76,118.00|0|20|0.00|16,696.00|Pesos
						 * 1					|22/10/13					|A			|15				|00		|4899	|		|K10000370885			 |600.00|00030248
						 * consecutivo(NA)	|fechaOperacion(dd-MM-yy)	|naturaleza	|tipoOperacion	|(NA)	|(NA)	|(NA)	|'K'referencia'[NN]'|monto	|(NA)
						 * 0					|1							|2			|3				|4		|5		|6		|7						 |8		|9 **/

						fechaOperacion	=arreglo[1].trim();
						naturaleza		=arreglo[2].trim();
						tipoOperacion	=arreglo[3].trim();
						referencia		=arreglo[7].trim();
						monto			=arreglo[8].trim().replaceAll(",","").replaceAll("\\$","");
						numIdArchivo	=arreglo[9].trim();

						/**Se lee el numero de transaccion del archivo y se concatena con la fecha**/
						fechaNumId = fechaOperacion.replaceAll("/","");
						numIdArchivo = numIdArchivo +fechaNumId;
						depRefe.setNumIdenArchivo(numIdArchivo);

						DepositosRefeBean refeBean = new DepositosRefeBean();

						refeBean = ValNumIdArch(depRefe,2);

						SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yy"); //dia-mes-año
						dateFormat.setLenient(false);

						/**Valida tipo de canal elegido en pantalla**/
						if(depositosRefeBean.getTipoCanal().equals("2")){
							/**Valida el formato de fecha**/
							if (!fechaOperacion.isEmpty() && fechaOperacion.length() == dateFormat.toPattern().length()){
								dateFormat.parse(fechaOperacion.trim());
								auxFecha = fechaOperacion.split("\\/");
								fechaOperacion = "20"+auxFecha[2]+"-"+auxFecha[1]+"-"+auxFecha[0];
								depRefe.setFechaOperacion(fechaOperacion);
								Date fechaInicial;
								Date fechaFinal;
								Date fechaConcilia;

								fechaInicial 	= OperacionesFechas.conversionStrDate(depositosRefeBean.getFechaCargaInicial());
								fechaFinal 		= OperacionesFechas.conversionStrDate(depositosRefeBean.getFechaCargaFinal());
								fechaConcilia   = OperacionesFechas.conversionStrDate(fechaOperacion);

								if((fechaConcilia.after(fechaInicial) && fechaConcilia.before(fechaFinal) || fechaConcilia.equals(fechaInicial) || fechaConcilia.equals(fechaFinal)) &&  arreglo[3].trim().equals("15") ){
									/**Valida la naturaleza del movimiento**/
									if(naturaleza.length() ==1 && (naturaleza.equals("A") || naturaleza.equals("C"))){
										depRefe.setNatMovimiento(naturaleza);

										/**Valida el tipo de operación del movimiento**/
										if(esCantidadPositivaMPA(tipoOperacion)){
											depRefe.setTipoMov(tipoOperacion);
											if(referencia.length()<3){
												referencia = "";
											}else{
												referencia=referencia.substring(1).substring(0, referencia.length()-3);
											}

											/**Valida el tamaño de la referencia del movimiento**/
											if(referencia.length()<=tamReferencia){
												/**Valida que la referencia no venga vacia**/
												if(referencia.length()>0){
													depRefe.setReferenciaMov(referencia);
													/**Se convierte a entero la referencia, si este da como resultado cero, no entrara en la carga**/
													if(Utileria.convierteLong(referencia)!=0){
														depRefe.setReferenciaMov(referencia);

														if(refeBean.getNumReg()==0){
															/**Valida el monto**/
															if(esCantidadPositiva(monto) && Utileria.convierteDoble(monto)>0){

																/**Valida el saldo de la cuenta de ahorro**/
																MensajeTransaccionBean mensaje=new MensajeTransaccionBean();//mensaje transaccion
																mensaje=cuentasAhoDAO.depCuentasValDR(depRefe);

																if(mensaje.getNumero()== 0){
																	depRefe.setMontoMov(monto);
																	depRefe.setValidacion("CORRECTO");
																	depRefe.setNumVal("0");
																}else{
																	depRefe.setNumVal(String.valueOf(mensaje.getNumero()));
																	depRefe.setValidacion(mensaje.getDescripcion());
																}
															}else{
																depRefe.setMontoMov(monto);
																depRefe.setValidacion("Valor incorrecto para monto de movimiento.");
																depRefe.setNumVal("5");
															}
															/**
															 * ACA SE AGREGA LA VALIDACION PARA DETECTAR EN LISTAS DE PERSONAS BLOQUEADAS
															 *
															 */
															PLDListasPersBloqBean pldListasPersBloqBean = new PLDListasPersBloqBean();
															SeguimientoPersonaListaBean seguimientoPersonaListaBean = new SeguimientoPersonaListaBean();
															CuentasAhoBean cuentasAhoBean = new CuentasAhoBean();

															cuentasAhoBean.setCuentaAhoID(referencia);
															cuentasAhoBean = cuentasAhoDAO.consultaPrincipal(cuentasAhoBean, 1);
															if(cuentasAhoBean != null){
																	pldListasPersBloqBean.setPersonaBloqID(cuentasAhoBean.getClienteID());
																	pldListasPersBloqBean.setTipoPers("CTE");
																	pldListasPersBloqBean.setCuentaAhoID(cuentasAhoBean.getCuentaAhoID());
																}else{
																	pldListasPersBloqBean = null;
															}

															if(pldListasPersBloqBean!= null){

																PLDListasPersBloqBean listasPersBloqBean = pldListasPersBloqDAO.consultaEstaBloq(pldListasPersBloqBean, 2);
																seguimientoPersonaListaBean.setTipoLista(pldListasPersBloqBean.getTipoPers());
																seguimientoPersonaListaBean.setListaDeteccion("LPB");
																seguimientoPersonaListaBean.setNumRegistro(pldListasPersBloqBean.getPersonaBloqID());
																SeguimientoPersonaListaBean listaSeguimientoBean  = seguimientoPersonaListaDAO.consultaPermite(seguimientoPersonaListaBean, 2);
																if(listasPersBloqBean.getEstaBloqueado().equalsIgnoreCase("S") && listaSeguimientoBean.getPermiteOperacion().equalsIgnoreCase("N")){
																	depRefe.setValidacion("Motivo: Persona en Lista de Personas Bloqueadas."+" Folio: "+listaSeguimientoBean.getOpeInusualID());
																	depRefe.setNumVal("17");

																}
															}
															//Fin validacion de personas en listas bloqueadas

														}else{
															depRefe.setFechaOperacion(fechaOperacion);
															depRefe.setNatMovimiento(naturaleza);
															depRefe.setTipoMov(tipoOperacion);
															depRefe.setReferenciaMov(referencia);
															depRefe.setMontoMov(monto);
															depRefe.setValidacion("El registro ya fue procesado.");
															depRefe.setNumVal("16");
														}
													}else{
														/**Valida que la suma de los numeros de la Referencia no sea cero**/
														depRefe.setReferenciaMov(arreglo[7].trim());
														depRefe.setMontoMov(monto);
														depRefe.setValidacion("Referencia bancaria no identificada.");
														depRefe.setNumVal("6");
													}
												}else{
													depRefe.setReferenciaMov(arreglo[7].trim());
													depRefe.setMontoMov(monto);
													depRefe.setValidacion("La referencia se encuentra vacía.");
													depRefe.setNumVal("9");
												}
											}else{
												depRefe.setReferenciaMov(arreglo[7].trim());
												depRefe.setMontoMov(monto);
												depRefe.setValidacion("La longitud de la referencia es mayor al tamaño máximo(38).");
												depRefe.setNumVal("10");
											}
										}else{
											depRefe.setTipoMov(tipoOperacion);
											depRefe.setReferenciaMov(referencia);
											depRefe.setMontoMov(monto);
											depRefe.setValidacion("Valor incorrecto en tipo de operación.");
											depRefe.setNumVal("11");
										}
									}else{
										depRefe.setNatMovimiento(naturaleza);
										depRefe.setTipoMov(tipoOperacion);
										depRefe.setReferenciaMov(referencia);
										depRefe.setMontoMov(monto);
										depRefe.setValidacion("Valor incorrecto en la naturaleza del movimiento.");
										depRefe.setNumVal("12");
									}

								} else {
									depRefe.setNatMovimiento(naturaleza);
									depRefe.setTipoMov(tipoOperacion);
									depRefe.setReferenciaMov(referencia);
									depRefe.setMontoMov(monto);
									depRefe.setNumVal("13");
									if(!((fechaConcilia.after(fechaInicial) && fechaConcilia.before(fechaFinal) || fechaConcilia.equals(fechaInicial) || fechaConcilia.equals(fechaFinal))) && !arreglo[3].trim().equals("15")){
										depRefe.setValidacion("La fecha de los movimientos no coincide con el rango de fechas de carga y el tipo de movimiento es diferente a Efectivo para pago de Crédito (15).");
									}else if(	!( (fechaConcilia.after(fechaInicial) && fechaConcilia.before(fechaFinal) || fechaConcilia.equals(fechaInicial) || fechaConcilia.equals(fechaFinal))) && arreglo[3].trim().equals("15")){
										depRefe.setValidacion("La fecha de los movimientos no coincide con el rango de fechas de carga.");
									}else if(	( (fechaConcilia.after(fechaInicial) && fechaConcilia.before(fechaFinal) || fechaConcilia.equals(fechaInicial) || fechaConcilia.equals(fechaFinal))) && !arreglo[3].trim().equals("15")){
										depRefe.setValidacion("El tipo de movimiento es diferente a Efectivo para pago de Crédito (15) .");
									}else{
										depRefe.setValidacion("El tipo de movimiento no identificado.");
									}
								}
							}else{
								depRefe.setFechaOperacion(Constantes.FECHA_VACIA);
								depRefe.setNatMovimiento(naturaleza);
								depRefe.setTipoMov(tipoOperacion);
								depRefe.setReferenciaMov(referencia);
								depRefe.setMontoMov(monto);
								depRefe.setValidacion("Formato incorrecto en fecha de operación. ");
								depRefe.setNumVal("14");
							}
						}else{
							depRefe.setFechaOperacion(fechaOperacion);
							depRefe.setNatMovimiento(naturaleza);
							depRefe.setTipoMov(tipoOperacion);
							depRefe.setReferenciaMov(referencia);
							depRefe.setMontoMov(monto);
							depRefe.setValidacion("El tipo de canal es incorrecto para la carga de archivo.");
							depRefe.setNumVal("15");
						}

					}else{
						depRefe.setDescError(" Error en línea: "+numeroLinea +"Asegúrese de seleccionar el formato del archivo correctamente.");
						depRefe.setNumError("666");
						depRefe.setLineaError(numeroLinea);
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+depRefe.getDescripcionMov());
					}
					listaDep.add(depRefe);
				}
			}
		}catch (Exception e) {
			e.printStackTrace();
			listaDep=null;
		}
		return listaDep;
	}

	public List<DepositosRefeBean> leeArchivoBanorte(DepositosRefeBean depositosRefeBean, String rutaArchivo){
		ArrayList<DepositosRefeBean> listaDep = new ArrayList<DepositosRefeBean>();
		BufferedReader bufferedReader;
		String [] arreglo = null;

		int numeroLinea =0;
		DepositosRefeBean depRefe;
		String renglon;

		int tamEncabezado = 1;
		int tamReferencia = 40;/**40 que pide el store maximo(se aumento el maximo de caracteres de 35 a 40 para la f)**/
		int numCamposEncabezado = 15;
		/**encabezados**/
		String fechaOperacion	="";
		String [] auxFecha		=null;
		String naturaleza		="";
		String referencia		="";
		String monto			="";
		String tipoDeposito		="";

		try {
			bufferedReader = new BufferedReader(new FileReader(rutaArchivo));

			while ((renglon = bufferedReader.readLine())!= null){
				numeroLinea +=1;
				if(tamEncabezado<numeroLinea && !renglon.trim().equals("") ){
					depRefe = new DepositosRefeBean();
					arreglo = renglon.split("\\|");
					depRefe.setNumError("0");
					depRefe.setNumCtaInstit(arreglo[0].trim());
					if(arreglo.length==numCamposEncabezado ){
						/**NumFactura|Referencia 1|Referencia 2|Referencia 3|Referencia 4|Importe Bruto|Descuentos/Recargos|Importe Neto|Medio de Pago|Forma de Pago|Folio de Pago|Sucursal|Hora|Fecha Vencimiento|Fecha de Pago**/

						/**Se reemplazan los caracteres especiales en las referencias**/
						if(arreglo[1].trim().equals("")){
							if(arreglo[2].trim().equals("")){
								if(arreglo[3].trim().equals("")){
									if(arreglo[4].trim().equals("")){
										referencia		="";
									}else{
										referencia		=arreglo[4].trim().replaceFirst("^0+(?!$)", "");
										referencia		=referencia.substring(0, referencia.length()-1);
									}
								}else{
									referencia		=arreglo[3].trim().replaceFirst("^0+(?!$)", "");
									referencia		=referencia.substring(0, referencia.length()-1);
								}
							}else{
								referencia		=arreglo[2].trim().replaceFirst("^0+(?!$)", "");
								referencia		=referencia.substring(0, referencia.length()-1);
							}
						}else{
							referencia		=arreglo[1].trim().replaceFirst("^0+(?!$)", "");
							referencia		=referencia.substring(0, referencia.length()-1);
						}

						/**Se asigna el tipo de deposito**/
						if(arreglo[8].trim().equals("Ventanilla")){
							tipoDeposito = "E";
						}else{
							if(arreglo[8].trim().equals("Internet")){
								tipoDeposito = "T";
							}else{
								tipoDeposito = "";
							}
						}
						/**Se obtiene la fecha de operacion**/
						fechaOperacion	=arreglo[14].trim();
						/**Como en el archivo de banorte no se determina la natulareza, se le asigna la naturaleza tipo Abono (A)**/
						naturaleza		="A";
						/**Se reemplazan los caracteres especiales en el monto**/
						monto			=arreglo[7].trim().replaceAll(",","").replaceAll("\\$","");
						/**Se convierte el formato de la fecha**/
						SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yy"); //dia/mes/año
						dateFormat.setLenient(false);

						try{
							dateFormat.parse(fechaOperacion);
							auxFecha = fechaOperacion.split("\\/");
							fechaOperacion = auxFecha[2]+"-"+auxFecha[1]+"-"+auxFecha[0];

							Date fechaInicial;
							Date fechaFinal;
							Date fechaOp;

							fechaInicial 	= OperacionesFechas.conversionStrDate(depositosRefeBean.getFechaCargaInicial());
							fechaFinal 		= OperacionesFechas.conversionStrDate(depositosRefeBean.getFechaCargaFinal());
							fechaOp    		= OperacionesFechas.conversionStrDate(fechaOperacion);

							if( (fechaOp.after(fechaInicial) && fechaOp.before(fechaFinal) ||
									fechaOp.equals(fechaInicial) || fechaOp.equals(fechaFinal))){

								depRefe.setFechaOperacion(fechaOperacion);

								if(referencia.length()<=tamReferencia){

									if(referencia.length()>0){

										depRefe.setReferenciaMov(referencia);

										if(esCantidadPositivaMPA(monto) && Utileria.convierteDoble(monto)>0){

											depRefe.setMontoMov(monto);

											if(depositosRefeBean.getTipoCanal().equals("2")){

												/**Valida la el monto de la cuenta de ahorro**/
												MensajeTransaccionBean mensaje=new MensajeTransaccionBean();//mensaje transaccion
												mensaje=cuentasAhoDAO.depCuentasValDR(depRefe);

												if(mensaje.getNumero()== 0){
													depRefe.setNatMovimiento(naturaleza);
													depRefe.setTipoDeposito(tipoDeposito);
													depRefe.setTipoMov("1");
													depRefe.setValidacion("CORRECTO");
													depRefe.setNumVal("0");
												}else{
													if(mensaje.getNumero()==3){
														depRefe.setValidacion(mensaje.getDescripcion());
														depRefe.setNumVal("3");
													}else{
														if(mensaje.getNumero()==4){
															depRefe.setValidacion(mensaje.getDescripcion());
															depRefe.setNumVal("4");
														}else{
															if(mensaje.getNumero()==1){
																depRefe.setValidacion(mensaje.getDescripcion());
																depRefe.setNumVal("1");
															}else{
																if(mensaje.getNumero()==2){
																	depRefe.setValidacion(mensaje.getDescripcion());
																	depRefe.setNumVal("2");
																}
															}
														}
													}
												}
											}else{
												if(!depositosRefeBean.getTipoCanal().equals("2")){
													depRefe.setNatMovimiento(naturaleza);
													depRefe.setTipoDeposito(tipoDeposito);
													depRefe.setTipoMov("1");
													depRefe.setValidacion("CORRECTO");
													depRefe.setNumVal("0");
												}
											}
											/**
											 * Aca se va agregar la validacion para las personas en listas bloquedas segun el tipo de canal
											 *
											 */
											PLDListasPersBloqBean pldListasPersBloqBean = new PLDListasPersBloqBean();
											SeguimientoPersonaListaBean seguimientoPersonaListaBean = new SeguimientoPersonaListaBean();
											switch(Utileria.convierteEntero(depositosRefeBean.getTipoCanal())){
													case 1:
														CreditosBean creditosBean = new CreditosBean();
														creditosBean.setCreditoID(depRefe.getReferenciaMov());
														creditosBean =	creditosDAO.consultaPrincipal(creditosBean, 1);
															if(creditosBean != null){

															pldListasPersBloqBean.setPersonaBloqID(creditosBean.getClienteID());
															pldListasPersBloqBean.setTipoPers("CTE");
															pldListasPersBloqBean.setCreditoID(creditosBean.getCreditoID());
															}else{
																pldListasPersBloqBean = null;
															}
														break;
													case 2:
															CuentasAhoBean cuentasAhoBean = new CuentasAhoBean();
															cuentasAhoBean.setCuentaAhoID(depRefe.getReferenciaMov());
															cuentasAhoBean = cuentasAhoDAO.consultaPrincipal(cuentasAhoBean, 1);
															if(cuentasAhoBean != null){
																pldListasPersBloqBean.setPersonaBloqID(cuentasAhoBean.getClienteID());
																pldListasPersBloqBean.setTipoPers("CTE");
																pldListasPersBloqBean.setCuentaAhoID(cuentasAhoBean.getCuentaAhoID());
															}else{
																pldListasPersBloqBean = null;
															}
														break;
													case 3:
															pldListasPersBloqBean.setPersonaBloqID(depRefe.getReferenciaMov());
															pldListasPersBloqBean.setTipoPers("CTE");
														break;

											}

											if(pldListasPersBloqBean!= null){
												PLDListasPersBloqBean listasPersBloqBean = pldListasPersBloqDAO.consultaEstaBloq(pldListasPersBloqBean, 2);
												seguimientoPersonaListaBean.setTipoLista(pldListasPersBloqBean.getTipoPers());
												seguimientoPersonaListaBean.setListaDeteccion("LPB");
												seguimientoPersonaListaBean.setNumRegistro(pldListasPersBloqBean.getPersonaBloqID());
												SeguimientoPersonaListaBean listaSeguimientoBean  = seguimientoPersonaListaDAO.consultaPermite(seguimientoPersonaListaBean, 2);
												if(listasPersBloqBean.getEstaBloqueado().equalsIgnoreCase("S") && listaSeguimientoBean.getPermiteOperacion().equalsIgnoreCase("N")){
													depRefe.setValidacion("Persona en Lista de Personas Bloqueadas. Linea: " + numeroLinea+" Folio: "+listaSeguimientoBean.getOpeInusualID());
													depRefe.setNumVal("10");

												}
											}

										}else{
											depRefe.setMontoMov(monto);
											depRefe.setFechaOperacion(fechaOperacion);
											depRefe.setNatMovimiento(naturaleza);
											depRefe.setReferenciaMov(referencia);
											depRefe.setTipoDeposito(tipoDeposito);
											depRefe.setTipoMov("1");
											depRefe.setValidacion("Formato incorrecto para Monto de Movimiento. Linea: " + numeroLinea);
											depRefe.setNumVal("5");
										}
									}else{
										depRefe.setMontoMov(monto);
										depRefe.setFechaOperacion(fechaOperacion);
										depRefe.setNatMovimiento(naturaleza);
										depRefe.setReferenciaMov(referencia);
										depRefe.setTipoDeposito(tipoDeposito);
										depRefe.setTipoMov("1");
										depRefe.setValidacion("La Referencia se encuentra vacía. Linea: " + numeroLinea);
										depRefe.setNumVal("6");
									}
								}else{
									depRefe.setMontoMov(monto);
									depRefe.setFechaOperacion(fechaOperacion);
									depRefe.setNatMovimiento(naturaleza);
									depRefe.setReferenciaMov(referencia);
									depRefe.setTipoDeposito(tipoDeposito);
									depRefe.setTipoMov("1");
									depRefe.setValidacion("Sobre pasa el tamaño máximo para Referencia. Linea: " + numeroLinea);
									depRefe.setNumVal("7");
								}
							}else{
								depRefe.setMontoMov(monto);
								depRefe.setFechaOperacion(fechaOperacion);
								depRefe.setNatMovimiento(naturaleza);
								depRefe.setReferenciaMov(referencia);
								depRefe.setTipoDeposito(tipoDeposito);
								depRefe.setTipoMov("1");
								depRefe.setValidacion("La Fecha esta Fuera del Rango de Fechas. Linea: "+numeroLinea);
								depRefe.setNumVal("8");
							}
						}catch(Exception  e){
							depRefe.setMontoMov(monto);
							depRefe.setFechaOperacion(Constantes.FECHA_VACIA);
							depRefe.setNatMovimiento(naturaleza);
							depRefe.setReferenciaMov(referencia);
							depRefe.setTipoDeposito(tipoDeposito);
							depRefe.setTipoMov("1");
							depRefe.setValidacion("Formato Incorrecto en Fecha de Operación. Linea: " + numeroLinea);
							depRefe.setNumVal("9");
						}
					}else{
						depRefe.setDescError(" Error en línea: " +numeroLinea +saltoLinea+" Motivo: Asegúrese de seleccionar el formato del archivo correctamente.");
						depRefe.setNumError("666");
						depRefe.setLineaError(numeroLinea);
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+depRefe.getDescripcionMov());
					}
					listaDep.add(depRefe);
				}
			}
		}catch (Exception e) {
			e.printStackTrace();

			listaDep=null;
		}
		return listaDep;
	}


	public List<DepositosRefeBean> leerArchivoBancomer(DepositosRefeBean depositosRefeBean,String rutaArchivo){
		ArrayList<DepositosRefeBean> listaDep = new ArrayList<DepositosRefeBean>();
		BufferedReader bufferedReader;

		int contador =1;
		int numeroLinea =0;
		DepositosRefeBean depRefe;
		String renglon;
		String cuentaBanco = "";
		String numIdenArchivo = "";
		int numFila = 0;
		try {
			bufferedReader = new BufferedReader(new FileReader(rutaArchivo));
			while ((renglon = bufferedReader.readLine())!= null){
				depRefe = new DepositosRefeBean();
				numeroLinea+=1;
				String referencia = "";
				String concepto = "";
				String referenciaAmpliada = "";
				String cargoAbono = "";
				String importe="";
				String codigoLeyenda="";
				String fechaOperacion = "";
				String fechaValor="";
				String tipoCanal = "";
				String auxFechaO[];
				String auxFechaV[];

				numFila++;
				depRefe.setNumeroFila(""+numFila);
				depRefe.setAplicarDeposito("N");
				depRefe.setNombreArchivoCarga(rutaArchivo);

				if(numeroLinea == 1){
					cuentaBanco = renglon.substring(2,20);
					numIdenArchivo = renglon.substring(0,20);
				}else{
					tipoCanal = renglon.substring(11,12);
					referencia = renglon.substring(11, 26);
					concepto = renglon.substring(26, 51);
					referenciaAmpliada = renglon.substring(51,88);
					cargoAbono = renglon.substring(88,89);

					importe = renglon.substring(89,105);
					codigoLeyenda = renglon.substring(121,124);
					fechaOperacion = renglon.substring(128,136);
					fechaValor = renglon.substring(144,152);


				depRefe.setNumIdenArchivo(numIdenArchivo);
				depRefe.setNumCtaInstit(cuentaBanco);
				depRefe.setReferenciaMov(referencia);
				depRefe.setDescripcionMov(referenciaAmpliada);
				depRefe.setTipoCanal(tipoCanal);
				Date fechaInicial;
				Date fechaFinal;
				Date fechaOp;

				fechaInicial = OperacionesFechas.conversionStrDate(depositosRefeBean.getFechaCargaInicial());
				fechaFinal 	= OperacionesFechas.conversionStrDate(depositosRefeBean.getFechaCargaFinal());


				auxFechaO = fechaOperacion.split("\\/");
				fechaOperacion = "20"+auxFechaO[2]+"-"+auxFechaO[1]+"-"+auxFechaO[0];

				auxFechaV = fechaValor.split("\\/");
				fechaValor = "20"+auxFechaV[2]+"-"+auxFechaV[1]+"-"+auxFechaV[0];

				fechaOp    = OperacionesFechas.conversionStrDate(fechaValor);

				depRefe.setFechaOperacion(fechaValor);

				if(cargoAbono.equals("1")){
					depRefe.setNatMovimiento("C");
				}else{
					depRefe.setNatMovimiento("A");
				}
				depRefe.setMontoMov(importe);
				depRefe.setFechaValor(fechaValor);

				CatCodigoLeyendaBean catCodigoLeyenda = new CatCodigoLeyendaBean();
				catCodigoLeyenda.setCodigoLeyenda(codigoLeyenda);
				catCodigoLeyenda.setTipoDeposito(Constantes.STRING_VACIO);
				catCodigoLeyenda = consultaCodigoLeyenda(catCodigoLeyenda,1);


					depRefe.setTipoDeposito(catCodigoLeyenda.getTipoDeposito());

				if( (fechaOp.after(fechaInicial) && fechaOp.before(fechaFinal) || fechaOp.equals(fechaInicial) || fechaOp.equals(fechaFinal))){
					if(depRefe.getReferenciaMov().trim().length()==15){
						if(depRefe.getNatMovimiento().equalsIgnoreCase("C")||depRefe.getNatMovimiento().equalsIgnoreCase("A")){
							if(Utileria.convierteDoble(depRefe.getMontoMov())>0){
									depRefe.setNumError("0");
									depRefe.setValidacion("CORRECTO");
									depRefe.setFechaOperacion(fechaValor);

									/**
									 *Aca se agrega validacion para deteccion en listas de perosnas bloquedas
									 *
									 */
									PLDListasPersBloqBean pldListasPersBloqBean = new PLDListasPersBloqBean();
									SeguimientoPersonaListaBean seguimientoPersonaListaBean = new SeguimientoPersonaListaBean();
									switch(Utileria.convierteEntero(depRefe.getTipoCanal())){
										case 1:
											CreditosBean creditosBean = new CreditosBean();
											creditosBean.setCreditoID(depRefe.getReferenciaMov());
											creditosBean =	creditosDAO.consultaPrincipal(creditosBean, 1);
											if(creditosBean != null){

											pldListasPersBloqBean.setPersonaBloqID(creditosBean.getClienteID());
											pldListasPersBloqBean.setTipoPers("CTE");
											pldListasPersBloqBean.setCreditoID(creditosBean.getCreditoID());
											}else{
												pldListasPersBloqBean = null;
											}
										break;
										case 2:
											CuentasAhoBean cuentasAhoBean = new CuentasAhoBean();
											cuentasAhoBean.setCuentaAhoID(depRefe.getReferenciaMov());
											cuentasAhoBean = cuentasAhoDAO.consultaPrincipal(cuentasAhoBean, 1);
											if(cuentasAhoBean != null){
												pldListasPersBloqBean.setPersonaBloqID(cuentasAhoBean.getClienteID());
												pldListasPersBloqBean.setTipoPers("CTE");
												pldListasPersBloqBean.setCuentaAhoID(cuentasAhoBean.getCuentaAhoID());
											}else{
												pldListasPersBloqBean = null;
											}
										break;
										case 3:
											pldListasPersBloqBean.setPersonaBloqID(depRefe.getReferenciaMov());
											pldListasPersBloqBean.setTipoPers("CTE");
										break;

									}

									if(pldListasPersBloqBean!= null){
										PLDListasPersBloqBean listasPersBloqBean = pldListasPersBloqDAO.consultaEstaBloq(pldListasPersBloqBean, 2);
										seguimientoPersonaListaBean.setTipoLista(pldListasPersBloqBean.getTipoPers());
										seguimientoPersonaListaBean.setListaDeteccion("LPB");
										seguimientoPersonaListaBean.setNumRegistro(pldListasPersBloqBean.getPersonaBloqID());
										SeguimientoPersonaListaBean listaSeguimientoBean  = seguimientoPersonaListaDAO.consultaPermite(seguimientoPersonaListaBean, 2);
										if(listasPersBloqBean.getEstaBloqueado().equalsIgnoreCase("S") && listaSeguimientoBean.getPermiteOperacion().equalsIgnoreCase("N")){
											depRefe.setValidacion("Persona en Lista de Personas Bloqueadas. Linea: " + numeroLinea+" Folio: "+listaSeguimientoBean.getOpeInusualID());
											depRefe.setNumError("5");
											depRefe.setFechaOperacion(fechaValor);
										}
									}

							}else{
								depRefe.setNumError("4");
								depRefe.setValidacion("Monto de la operación Incorrecto. Linea. "+contador);
							}
						}else{
							depRefe.setNumError("3");
							depRefe.setValidacion("La Naturaleza del movimiento es incorrecta. Linea- "+contador);
						}
					}else{
						depRefe.setNumError("2");
						depRefe.setValidacion("La Longitud de la referencia no corresponde con la parametrizada con esta institución. Linea. "+contador);
					}
				}else{
					depRefe.setNumError("1");
					depRefe.setValidacion("La Fecha esta Fuera del Rango de Fechas. Linea. "+contador);
				}


				listaDep.add(depRefe);
				}
				contador++;
			}
		}catch (Exception e) {
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en lee archivo", e);

			listaDep=null;
		}
		return listaDep;
	}

	/**
	 * Metodo para leer los archivos de la institución BANCOMER(BBVA) que vengan del algoritmo 36
	 * Algoritmo Bancomer 36  (1 Dígito Verificador)
	 * @param depositosRefeBean
	 * @param rutaArchivo
	 * @return List<DepositosRefeBean>
	 */
	public List<DepositosRefeBean> leerArchivoBancomerALG36(DepositosRefeBean depositosRefeBean,String rutaArchivo){
		ArrayList<DepositosRefeBean> listaDep = new ArrayList<DepositosRefeBean>();
		BufferedReader bufferedReader;

		int contador = 1;
		DepositosRefeBean depRefe;
		String renglon;
		String numIdenArchivo 		= "";
		String tipoPagoEfectivo 	= "EFE";	// Tipo de Pago Efectivo
		String tipoPagoCoInmFir 	= "CIF"; 	// Tipo de Pago Cobro Inmediato en firme
		String tipoPagoCoInmSaBuFin = "CIS";	// Tipo de Pago Cobro Inmediato Salvo en Buen Fin
		String tipoPagoRemesa 		= "REM";	// Tipo de Pago Remesa
		String tPEfectivo 			= "E";		// Tipo Deposito Efectivo
		String tPOtro 				= "T";		// Tipo Deposito Otro
		String tCheque 				= "C";		// Tipo Deposito Cheque
		String tNoAplica 			= "N";		// Tipo Deposito NO Aplica
		String nAbono 				= "A";		// Tipo de Naturaleza Abono
		String VPrefere 			= "VP";		// Inicio de la Referencia: VP

		int numFila = 0;
		try {
			bufferedReader = new BufferedReader( new FileReader( rutaArchivo ) );

			while (( renglon = bufferedReader.readLine()) != null ){

				depRefe = new DepositosRefeBean();

				String fecha 			= "";
				String convenio 		= "";
				String tipoPago 		= "";
				String oficina 			= "";
				String guiaCIE 			= "";
				String referencia 		= "";
				String concepto 		= "";
				String importe 			= "";
				String fechaOperacion 	= "";
				String conceptoLargo  	= "";
				String referenciaVP  	= "";
				String referenciaTC  	= "";
				String referenciaNum  	= "";

				numFila++;
				depRefe.setNumeroFila(""+numFila);
				depRefe.setAplicarDeposito("N");
				depRefe.setNombreArchivoCarga(rutaArchivo);

				if ( renglon.trim().length() == 89 ) {
					// Se extrae la información del archivo .txt
					fecha 		= renglon.substring( 0, 6 );
					convenio 	= renglon.substring( 6, 14 );
					tipoPago 	= renglon.substring( 14, 17 );
					oficina 	= renglon.substring( 17, 21 );
					guiaCIE 	= renglon.substring( 21, 28 );
					referencia 	= renglon.substring( 28, 48 );
					concepto 	= renglon.substring( 48, 78 );
					importe 	= renglon.substring( 78, 89 );

					referenciaVP 	= renglon.substring( 28, 30 );
					referenciaTC 	= renglon.substring( 30, 31 );
					referenciaNum 	= renglon.substring( 30, 48 );

					// se asginan los valores extraidos del .txt
					numIdenArchivo = depositosRefeBean.getCuentaAhoID() + fecha;
					conceptoLargo = ( concepto.trim().length() > 0 ) ?
										concepto + ", " + "oficina: " + oficina + ", convenio: " + convenio + ", guiaCIE: " + guiaCIE :
										"oficina: " + oficina + ", convenio: " + convenio + ", guiaCIE: " + guiaCIE;

					depRefe.setNumIdenArchivo( numIdenArchivo );
					depRefe.setDescripcionMov( conceptoLargo );
					depRefe.setMontoMov( importe );
					depRefe.setNatMovimiento( nAbono );
					depRefe.setTipoCanal( referenciaTC );

					Date fechaInicial;
					Date fechaFinal;
					Date fechaOp;

					// Se asigna el tipo de deposito dependiendo de su tipo de Pago
					if (tipoPago.equals( tipoPagoEfectivo ) ) {

						depRefe.setTipoDeposito( tPEfectivo );

					} else {
						depRefe.setTipoDeposito( tPOtro );
					}

					// Se asginan la fecha de inicio y fin asignadas en la pantalla de Archivo Depósito Referenciado
					fechaInicial = OperacionesFechas.conversionStrDate( depositosRefeBean.getFechaCargaInicial() );
					fechaFinal 	= OperacionesFechas.conversionStrDate( depositosRefeBean.getFechaCargaFinal() );

					// Se genera la fecha de operacion
					fechaOperacion = "20" + fecha.substring( 4, 6 ) +"-"+ fecha.substring( 2, 4 ) +"-"+ fecha.substring( 0, 2 );
					fechaOp = OperacionesFechas.conversionStrDate( fechaOperacion );

					// Validacion para verificar que la referencia tiene el formato correcto del algoritmo 36
					if ( referencia.trim().length() == 17 && referenciaVP.equals( VPrefere ) &&
							( referenciaTC.equals( "1" ) || referenciaTC.equals( "2" ) || referenciaTC.equals( "3" ) ) &&
							 Utileria.esDouble(referenciaNum) ) {
						depRefe.setReferenciaMov( referencia );
						// Validación de que la fecha ingresada sea mayor a la fecha inicial y menor a la fecha final o que sea igual a la fecha inicial o igual a la fecha final
						if( (fechaOp.after( fechaInicial ) && fechaOp.before( fechaFinal ) || fechaOp.equals( fechaInicial ) || fechaOp.equals(fechaFinal))) {
							depRefe.setFechaOperacion( fechaOperacion );
							// Se valida que la refencia sea mayor a 0
							if( depRefe.getReferenciaMov().trim().length() > 0 ) {
								// Se valida que la naturaleza del movimiento sea Abono
								if( depRefe.getNatMovimiento().equalsIgnoreCase( nAbono ) ) {
									//Se valida que el monto ingresado sea mayor a 0
									if( Utileria.convierteDoble( depRefe.getMontoMov() ) > 0 ) {
											depRefe.setNumError( "0" );
											depRefe.setValidacion( "CORRECTO" );
									} else {
										depRefe.setNumError( "4" );
										depRefe.setValidacion( "Monto de la operación Incorrecto. Linea - " + contador );
									}
								} else {
									depRefe.setNumError( "3" );
									depRefe.setValidacion( "La Naturaleza del movimiento es incorrecta. Linea - " + contador );
								}
							}else{
								depRefe.setNumError("2");
								depRefe.setValidacion("La Longitud de la referencia no corresponde con la parametrizada con esta institución. Linea - " + contador );
							}
						}else{
							depRefe.setNumError("1");
							depRefe.setValidacion("La Fecha esta Fuera del Rango de Fechas. Linea - " + contador );
						}
					} else {
						depRefe.setNumError("6");
						depRefe.setValidacion("La Referencia tiene un formato incorrecto. Linea - " + contador );
					}
				} else {
					depRefe.setNumError("5");
					depRefe.setValidacion("La Longitud del deposito referenciado debe ser 89 caracteres. Linea -" + contador );
				}

				listaDep.add( depRefe );
				contador++;
			}

		}catch (Exception e) {
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en lee archivo", e);

			listaDep = null;
		}
		return listaDep;
	}


	public List<DepositosRefeBean> leeArchivo(DepositosRefeBean depositosRefeBean,String rutaArchivo){
		ArrayList<DepositosRefeBean> listaDep = new ArrayList<DepositosRefeBean>();
		BufferedReader bufferedReader;
		String [] arreglo = null;
		int contadorErr =0;
		int contador =1;
		DepositosRefeBean depRefe;
		String renglon;
		int numFila = 0;

		try {
			bufferedReader = new BufferedReader(new FileReader(rutaArchivo));

			while ((renglon = bufferedReader.readLine())!= null && !renglon.trim().equals("")){
				arreglo = renglon.split("\\|");
				depRefe = new DepositosRefeBean();
				/**NumCtaInstit|Fecha(yyyy-MM-dd)|ReferenciaDeposito|Descripcion|Naturaleza|Monto|MontoPendienteAplicar|canal|TipoDeposito|Moneda
				 * T - Tranferencia; E - Efectivo; C - Cheque
				 *Agregar campos que hacen falta
				 *0		  1			 2			3			   4 5		6	  7  8 9
				 *8049184|2012-01-01|1234567890|Pago a credito|A|123.89|37.00|01|E|01**/
				depRefe.setNumError("0");
				depRefe.setTipoMov("1");
				// DATOS FILAS LAYOUT
				numFila++;
				depRefe.setNumeroFila(""+numFila);
				depRefe.setAplicarDeposito("N");
				depRefe.setNombreArchivoCarga(rutaArchivo);

				if(depositosRefeBean.getNumCtaInstit().equals(arreglo[0].trim())){

					depRefe.setNumCtaInstit(arreglo[0].trim());

					if(validarFecha(arreglo[1])){
						Date fechaInicial;
						Date fechaFinal;
						Date fechaOp;

						fechaInicial = OperacionesFechas.conversionStrDate(depositosRefeBean.getFechaCargaInicial());
						fechaFinal 	= OperacionesFechas.conversionStrDate(depositosRefeBean.getFechaCargaFinal());
						fechaOp    = OperacionesFechas.conversionStrDate(arreglo[1]);

						if( (fechaOp.after(fechaInicial) && fechaOp.before(fechaFinal) || fechaOp.equals(fechaInicial) || fechaOp.equals(fechaFinal))){

							depRefe.setFechaOperacion(arreglo[1]);

							if(arreglo[2].length()<=150){

								depRefe.setReferenciaMov(arreglo[2]);

								if(arreglo[3].length()<=150){

									depRefe.setDescripcionMov(arreglo[3].trim());

									if(arreglo[4].equals("C") || arreglo[4].equals("A")){

										depRefe.setNatMovimiento(arreglo[4]);

										if(esCantidadPositivaMPA(arreglo[5].trim().replaceAll(",","").replaceAll("\\$","")) &&
												Utileria.convierteDoble(arreglo[5].trim().replaceAll(",","").replaceAll("\\$","")) > 0){

											depRefe.setMontoMov(arreglo[5]);

											if(esCantidadPositivaMPA(arreglo[6].trim().replaceAll(",","").replaceAll("\\$",""))){

												depRefe.setMontoPendApli(arreglo[6]);

												if(esCantidadPositiva(arreglo[7])){

													depRefe.setTipoCanal(arreglo[7]);

													if(arreglo[8].equals("E") || arreglo[8].equals("T") || arreglo[8].equals("C")){

														depRefe.setTipoDeposito(arreglo[8]);

														if(arreglo[7].trim().equals("2")){

															depRefe.setFechaOperacion(arreglo[1]);
															depRefe.setReferenciaMov(arreglo[2]);
															depRefe.setMontoMov(arreglo[5]);

															/** Se arma bean auxiliar para consultar la referencia de pago por instrumento.**/
															DepositosRefeBean depAux = new DepositosRefeBean();
															depAux.setInstitucionID(depositosRefeBean.getInstitucionID());
															depAux.setReferenciaMov(depRefe.getReferenciaMov());
															depAux.setTipoCanal(depRefe.getTipoCanal());

															ReferenciasPagosBean depositosAux = referenciasPagosDAO.consultaPrincipal(depAux, 1);

															/** Se guarda la referencia antes de resetearla por el número de cta, si es que se encuentra la referencia**/
															String numeroCuentaAux = depRefe.getReferenciaMov();
															/** Se busca el número de cuenta si es que existe en la tabla de REFPAGOSXINST.**/
															if(depositosAux.getExiste().equalsIgnoreCase("S")){
																depRefe.setReferenciaMov(depositosAux.getInstrumentoID());
															}

															MensajeTransaccionBean mensaje=new MensajeTransaccionBean();//mensaje transaccion
															mensaje=cuentasAhoDAO.depCuentasValDR(depRefe);

															/** Se vuelve a resetear el valor que trae inicial.**/
															depRefe.setReferenciaMov(arreglo[2]);

															if(mensaje.getNumero()== 0){
																depRefe.setTipoMoneda(arreglo[9]);
																depRefe.setValidacion("CORRECTO");
																depRefe.setNumVal("0");
															}else{
																if(mensaje.getNumero()==3){
																	depRefe.setValidacion(mensaje.getDescripcion());
																	depRefe.setNumVal("3");
																	depRefe.setNumError("114");
																}else{
																	if(mensaje.getNumero()==4){
																		depRefe.setValidacion(mensaje.getDescripcion());
																		depRefe.setNumVal("4");
																		depRefe.setNumError("115");
																	}else{
																		if(mensaje.getNumero()==1){
																			depRefe.setValidacion(mensaje.getDescripcion());
																			depRefe.setNumVal("1");
																			depRefe.setNumError("116");
																		}else{
																			if(mensaje.getNumero()==2){
																				depRefe.setValidacion(mensaje.getDescripcion());
																				depRefe.setNumVal("2");
																				depRefe.setNumError("117");
																			}
																		}
																	}
																}
															}
														}else{
															depRefe.setTipoDeposito(arreglo[8]);
														}

														/**
														 * TODOS LOS DATOS DE CARGA SON CORRECTOS SE REALIZA LA VALIDACION
														 * SI LA PERSONA
														 * SE ENCUENTRA EN LISTA DE PERSONAS BLOQUEADAS
														 */
														PLDListasPersBloqBean pldListasPersBloqBean = new PLDListasPersBloqBean();
														SeguimientoPersonaListaBean seguimientoPersonaListaBean = new SeguimientoPersonaListaBean();
														switch(Utileria.convierteEntero(depRefe.getTipoCanal())){
															case 1:

																/** Se arma bean auxiliar para consultar la referencia de pago por instrumento.**/
																DepositosRefeBean depAux1 = new DepositosRefeBean();
																depAux1.setInstitucionID(depositosRefeBean.getInstitucionID());
																depAux1.setReferenciaMov(depRefe.getReferenciaMov());
																depAux1.setTipoCanal(depRefe.getTipoCanal());

																ReferenciasPagosBean depositosAux1 = referenciasPagosDAO.consultaPrincipal(depAux1, 2);
																CreditosBean creditosBean = new CreditosBean();
																/** Se busca el número de cuenta si es que existe en la tabla de REFPAGOSXINST.**/
																if(depositosAux1.getExiste().equalsIgnoreCase("S")){

																	creditosBean.setCreditoID(depositosAux1.getInstrumentoID());
																}else{
																	creditosBean.setCreditoID(depRefe.getReferenciaMov());
																}

																creditosBean =	creditosDAO.consultaPrincipal(creditosBean, 1);

																	if(creditosBean != null){

																	pldListasPersBloqBean.setPersonaBloqID(creditosBean.getClienteID());
																	pldListasPersBloqBean.setTipoPers("CTE");
																	pldListasPersBloqBean.setCreditoID(creditosBean.getCreditoID());
																	}else{
																		pldListasPersBloqBean = null;
																	}
															break;
															case 2:

																	/** Se arma bean auxiliar para consultar la referencia de pago por instrumento.**/
																	DepositosRefeBean depAux2 = new DepositosRefeBean();
																	depAux2.setInstitucionID(depositosRefeBean.getInstitucionID());
																	depAux2.setReferenciaMov(depRefe.getReferenciaMov());
																	depAux2.setTipoCanal(depRefe.getTipoCanal());

																	ReferenciasPagosBean depositosAux2 = referenciasPagosDAO.consultaPrincipal(depAux2, 1);
																	CuentasAhoBean cuentasAhoBean = new CuentasAhoBean();
																	/** Se busca el número de cuenta si es que existe en la tabla de REFPAGOSXINST.**/
																	if(depositosAux2.getExiste().equalsIgnoreCase("S")){

																		cuentasAhoBean.setCuentaAhoID(depositosAux2.getInstrumentoID());
																	}else{
																		cuentasAhoBean.setCuentaAhoID(depRefe.getReferenciaMov());
																	}

																	cuentasAhoBean = cuentasAhoDAO.consultaPrincipal(cuentasAhoBean, 1);
																	if(cuentasAhoBean != null){
																		pldListasPersBloqBean.setPersonaBloqID(cuentasAhoBean.getClienteID());
																		pldListasPersBloqBean.setTipoPers("CTE");
																		pldListasPersBloqBean.setCuentaAhoID(cuentasAhoBean.getCuentaAhoID());
																	}else{
																		pldListasPersBloqBean = null;
																	}

															break;
															case 3:
																	pldListasPersBloqBean.setPersonaBloqID(depRefe.getReferenciaMov());
																	pldListasPersBloqBean.setTipoPers("CTE");
															break;

														}
														if(pldListasPersBloqBean!= null){
															PLDListasPersBloqBean listasPersBloqBean = pldListasPersBloqDAO.consultaEstaBloq(pldListasPersBloqBean, 2);
															seguimientoPersonaListaBean.setTipoLista(pldListasPersBloqBean.getTipoPers());
															seguimientoPersonaListaBean.setListaDeteccion("LPB");
															seguimientoPersonaListaBean.setNumRegistro(pldListasPersBloqBean.getPersonaBloqID());
															SeguimientoPersonaListaBean listaSeguimientoBean  = seguimientoPersonaListaDAO.consultaPermite(seguimientoPersonaListaBean, 2);
															if(listasPersBloqBean.getEstaBloqueado().equalsIgnoreCase("S") && listaSeguimientoBean.getPermiteOperacion().equalsIgnoreCase("N")){
																depRefe.setValidacion("Motivo: Persona en Lista de Personas Bloqueadas. Linea: " + contador+" Folio: "+listaSeguimientoBean.getOpeInusualID());
																depRefe.setNumVal("14");
																depRefe.setNumError("118");
															}
														}
														// FIN SECCION PARA DETECTAR PERSONAS BLOQUEDAS
													}else{
														depRefe.setTipoDeposito(arreglo[8]);
														depRefe.setValidacion("Motivo: Valor incorrecto para Tipo de Depósito. Linea: " + contador);
														depRefe.setNumVal("13");
														depRefe.setNumError("888");
													}
												}else{
													depRefe.setTipoCanal(arreglo[7]);
													depRefe.setTipoDeposito(arreglo[8]);
													depRefe.setValidacion("Motivo: Valor incorrecto para Tipo de Canal. Linea: " + contador);
													depRefe.setNumVal("12");
													depRefe.setNumError("777");
												}
											}else{
												depRefe.setMontoPendApli(arreglo[6]);
												depRefe.setTipoCanal(arreglo[7]);
												depRefe.setTipoDeposito(arreglo[8]);
												depRefe.setValidacion("Formato Incorrecto para el Monto Pendiente por Aplicar. Linea: " + contador);
												depRefe.setNumVal("11");
												depRefe.setNumError("666");
											}
										}else{
											depRefe.setMontoMov(arreglo[5]);
											depRefe.setMontoPendApli(arreglo[6]);
											depRefe.setTipoCanal(arreglo[7]);
											depRefe.setTipoDeposito(arreglo[8]);
											depRefe.setValidacion("Formato Incorrecto para el Monto del Movimiento. Linea: " + contador);
											depRefe.setNumVal("10");
											depRefe.setNumError("555");
										}
									}else{
										depRefe.setNatMovimiento(arreglo[4]);
										depRefe.setMontoMov(arreglo[5]);
										depRefe.setMontoPendApli(arreglo[6]);
										depRefe.setTipoCanal(arreglo[7]);
										depRefe.setTipoDeposito(arreglo[8]);
										depRefe.setValidacion("Formato incorrecto para Naturaleza. Linea: " + contador);
										depRefe.setNumVal("9");
										depRefe.setNumError("444");
									}
								}else{
									depRefe.setDescripcionMov(arreglo[3].trim());
									depRefe.setNatMovimiento(arreglo[4]);
									depRefe.setMontoMov(arreglo[5]);
									depRefe.setMontoPendApli(arreglo[6]);
									depRefe.setTipoCanal(arreglo[7]);
									depRefe.setTipoDeposito(arreglo[8]);
									depRefe.setValidacion("La Descripción no debe ser mayor a 150 caracteres. Linea: " + contador);
									depRefe.setNumVal("8");
									depRefe.setNumError("333");
								}
							}else{
								depRefe.setReferenciaMov(arreglo[2]);
								depRefe.setDescripcionMov(arreglo[3].trim());
								depRefe.setNatMovimiento(arreglo[4]);
								depRefe.setMontoMov(arreglo[5]);
								depRefe.setMontoPendApli(arreglo[6]);
								depRefe.setTipoCanal(arreglo[7]);
								depRefe.setTipoDeposito(arreglo[8]);
								depRefe.setValidacion("La Referencia no debe ser mayor a 150 caracteres. Linea: " + contador);
								depRefe.setNumVal("7");
								depRefe.setNumError("222");
							}
						}else{
							depRefe.setFechaOperacion(arreglo[1]);
							depRefe.setReferenciaMov(arreglo[2]);
							depRefe.setDescripcionMov(arreglo[3].trim());
							depRefe.setNatMovimiento(arreglo[4]);
							depRefe.setMontoMov(arreglo[5]);
							depRefe.setMontoPendApli(arreglo[6]);
							depRefe.setTipoCanal(arreglo[7]);
							depRefe.setTipoDeposito(arreglo[8]);
							depRefe.setValidacion("La Fecha esta Fuera del Rango de Fechas. Linea: " + contador);
							depRefe.setNumVal("5");
							depRefe.setNumError("112");
						}
					}else{
						depRefe.setFechaOperacion(Constantes.FECHA_VACIA);
						depRefe.setReferenciaMov(arreglo[2]);
						depRefe.setDescripcionMov(arreglo[3].trim());
						depRefe.setNatMovimiento(arreglo[4]);
						depRefe.setMontoMov(arreglo[5]);
						depRefe.setMontoPendApli(arreglo[6]);
						depRefe.setTipoCanal(arreglo[7]);
						depRefe.setTipoDeposito(arreglo[8]);
						depRefe.setValidacion("Formato Incorrecto en Fecha de Operación. Linea: " + contador);
						depRefe.setNumVal("6");
						depRefe.setNumError("111");
					}
				}else{
					depRefe.setFechaOperacion(Constantes.FECHA_VACIA);
					depRefe.setReferenciaMov(arreglo[2]);
					depRefe.setDescripcionMov(arreglo[3].trim());
					depRefe.setNatMovimiento(arreglo[4]);
					depRefe.setMontoMov(arreglo[5]);
					depRefe.setMontoPendApli(arreglo[6]);
					depRefe.setTipoCanal(arreglo[7]);
					depRefe.setTipoDeposito(arreglo[8]);
					depRefe.setValidacion("No Coinciden los Número de Cuenta. Linea: " + contador);
					depRefe.setNumVal("14");
					depRefe.setNumError("113");
				}
				if(!depRefe.getNumError().equals("0")){
					contadorErr++;
				}else{
					depRefe.setValidacion("CORRECTO");
				}
				listaDep.add(depRefe);
				contador++;
			}
		}catch (Exception e) {
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en lee archivo", e);

			listaDep=null;
		}
		return listaDep;
	}


	public boolean validarFecha(String fecha) {

		if (fecha == null)
			return false;

		SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd"); //año-mes-dia

		if (fecha.trim().length() != dateFormat.toPattern().length())
			return false;

		dateFormat.setLenient(false);

		try {
			dateFormat.parse(fecha.trim());
		}
		catch ( Exception pe) {
			return false;
		}
		return true;
	}


	public boolean esCantidadPositiva(String cantidad){
		float cantidadFloat=0;
		boolean resul=true;
		try{
			cantidadFloat = Float.parseFloat(cantidad);
			if(cantidadFloat<=0){ resul=false;}
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en cantidad positiva ", e);
			resul= false;
		}
		return resul;
	}
	public boolean esCantidadPositivaMPA(String cantidad){
		float cantidadFloat=0;
		boolean resul=true;
		try{
			cantidadFloat = Float.parseFloat(cantidad);
			if(cantidadFloat<0){ resul=false;}
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en cantidad positiva", e);
			resul= false;
		}
		return resul;
	}

	/**
	 * Aplicación de los depósitos referenciados seleccionados en el grid de manera masiva dentro de un SP
	 * @param depositosRefeBean
	 * @param pagosLista lista con los depósitos por aplicar.
	 * @param accion
	 * @return
	 */
	public MensajeTransaccionBean aplicaPagosRefMasivo(final DepositosRefeBean depositosRefBean, final List pagosLista, final String accion, final String formatoBanco) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		try {
			mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
				public Object doInTransaction(TransactionStatus transaction) {
					MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
					try {
						DepositosRefeBean depositosRefe = new DepositosRefeBean();
						int numAct = 1;

						for(int i=0; i<pagosLista.size(); i++){

							depositosRefe = (DepositosRefeBean)pagosLista.get(i);
							depositosRefBean.setNumTran(depositosRefe.getNumTran());
							depositosRefBean.setNumCtaInstit(depositosRefe.getNumCtaInstit());
							depositosRefe.setInstitucionID(depositosRefBean.getInstitucionID());
							depositosRefe.setBancoEstandar(depositosRefBean.getBancoEstandar());
							depositosRefe.setNumeroMov(depositosRefe.getTipoMov());

							// ACTUALIZACION DE LOS DEPOSITOS SELECCIONADOS DE PANTALLA PARA APLICAR EN EL PROCESO MASIVO
							mensajeBean = actAplicaDepRefMasivo(depositosRefe, numAct);
							if(mensajeBean.getNumero()!=0){
								throw new Exception(mensajeBean.getDescripcion());
							}
						}

					} catch (Exception e) {
						if(mensajeBean.getNumero()==0){
							mensajeBean.setNumero(999);
						}
						mensajeBean.setDescripcion(e.getMessage());
						transaction.setRollbackOnly();
						e.printStackTrace();
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error al realizar la actualizacion de depositos aplicar", e);
					}
					return mensajeBean;
				}
			});

			if(mensaje.getNumero()!=0){
				throw new Exception(mensaje.getDescripcion());
			}

			// APLICACION MASIVA DE DEPOSITOS REFERENCIADOS
			mensaje = aplicaDepRefMasivoPro(depositosRefBean);
			if(mensaje.getNumero()!=0){
				throw new Exception(mensaje.getDescripcion());
			}

		} catch (Exception e) {
			if(mensaje.getNumero()==0){
				mensaje.setNumero(999);
			}
			mensaje.setDescripcion(e.getMessage());
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error al realizar la operacion", e);
		}
		return mensaje;
	}

	public MensajeTransaccionBean actAplicaDepRefMasivo(final DepositosRefeBean depositosRefBean, final int numeroAct) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {

								String query = "call ARCHIVOCARGADEPREFACT(?,?,?,?,?," +
														"?,?,?," +			// parametros de salida
														"?,?,?,?,?,?,?);"; 	// parametros auditoria

								CallableStatement sentenciaStore = arg0.prepareCall(query);

								sentenciaStore.setLong("Par_NumTran",Utileria.convierteLong(depositosRefBean.getNumTran()));
								sentenciaStore.setLong("Par_FolioCargaID",Utileria.convierteLong(depositosRefBean.getFolioCargaID()));
								sentenciaStore.setInt("Par_InstitucionID",Utileria.convierteEntero(depositosRefBean.getInstitucionID()));
								sentenciaStore.setString("Par_NumCtaInstit",depositosRefBean.getNumCtaInstit());
								sentenciaStore.setInt("Par_NumAct",numeroAct);

								//Parametros de Salida
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
									mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
									mensajeTransaccion.setDescripcion(resultadosStore.getString(2));
									mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
									mensajeTransaccion.setConsecutivoString(resultadosStore.getString(4));

								}else{
									mensajeTransaccion.setNumero(999);
									mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .DepositosRefeDAO.actAplicaDepRefMasivo");
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
						throw new Exception(Constantes.MSG_ERROR + " .DepositosRefeDAO.actAplicaDepRefMasivo");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en actualizacion de carga de depositos referenciados aplicar" + e);
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

	public MensajeTransaccionBean aplicaDepRefMasivoPro(final DepositosRefeBean depositosRefBean) {
		MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
		try {
			// Query con el Store Procedure
			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
				new CallableStatementCreator() {
					public CallableStatement createCallableStatement(Connection arg0) throws SQLException {

						String query = "call DEPOSITOREFEREMASIVOPRO(?,?,?,?,?," +
												"?,?,?," +			// parametros de salida
												"?,?,?,?,?,?,?);"; 	// parametros auditoria

						CallableStatement sentenciaStore = arg0.prepareCall(query);

						sentenciaStore.setLong("Par_NumTran",Utileria.convierteLong(depositosRefBean.getNumTran()));
						sentenciaStore.setInt("Par_InstitucionID",Utileria.convierteEntero(depositosRefBean.getInstitucionID()));
						sentenciaStore.setString("Par_NumCtaInstit",depositosRefBean.getNumCtaInstit());
						sentenciaStore.setString("Par_BancoEstandar",depositosRefBean.getBancoEstandar());
						sentenciaStore.registerOutParameter("Par_Consecutivo", Types.BIGINT);

						//Parametros de Salida
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
							mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
							mensajeTransaccion.setDescripcion(resultadosStore.getString(2));
							mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
							mensajeTransaccion.setConsecutivoString(resultadosStore.getString(4));

						}else{
							mensajeTransaccion.setNumero(999);
							mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .DepositosRefeDAO.aplicaDepRefMasivoPro");
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
				throw new Exception(Constantes.MSG_ERROR + " .DepositosRefeDAO.aplicaDepRefMasivoPro");
			}else if(mensajeBean.getNumero()!=0){
				throw new Exception(mensajeBean.getDescripcion());
			}
		} catch (Exception e) {
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en proceso masivo de aplicacion de depositos referenciados" + e);
			e.printStackTrace();
			if (mensajeBean.getNumero() == 0) {
				mensajeBean.setNumero(999);
			}
			mensajeBean.setDescripcion(e.getMessage());
		}
		return mensajeBean;
	}

	public List<DepositosRefeBean> leeArchivoETL(DepositosRefeBean depositosRefeBean,String rutaArchivo, String numTransaccion){
		List<DepositosRefeBean> listaDep = null;
		MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();

		try{
			depositosRefeBean.setTipoMoneda((depositosRefeBean.getTipoMoneda()== null)?"0":depositosRefeBean.getTipoMoneda());

			// PARAMETROS PROCESOSETL
			ProcesosETLBean procesosETLBean = new ProcesosETLBean();
			procesosETLBean.setProcesoETLID("1");//id del proceso ETL TABLA PROCESOSETL

			String[] parametros = {
				rutaArchivo, // "Par_RutaArchivoCarga",
				depositosRefeBean.getInstitucionID(),//  "Par_InstitucionID",
				depositosRefeBean.getNumCtaInstit(),// "Par_NumCtaInstit",
				depositosRefeBean.getBancoEstandar(),// "Par_BancoEstandar",
				depositosRefeBean.getFechaCargaInicial(),// "Par_FechaCargaInicial",
				depositosRefeBean.getFechaCargaFinal(), // "Par_FechaCargaFinal",
				depositosRefeBean.getTipoCanal(), // "Par_TipoCanal",
				depositosRefeBean.getTipoMoneda(), // "Par_TipoMoneda",
				numTransaccion // "Par_TransaccionID",
			};

			// EJECUCION DEL SH QUE PROCESA EL ETL PARA LEER EL ARCHIVO
			mensajeBean = procesosETLDAO.procesarArchivoSH(procesosETLBean, parametros);

			if(mensajeBean.getNumero() != 0){
				throw new Exception(mensajeBean.getDescripcion());
			}

			// VALIADA Y PROCESA LA INFORMACION
			mensajeBean = procesaCargaDepRef(depositosRefeBean);
			if(mensajeBean.getNumero() != 0){
				throw new Exception(mensajeBean.getDescripcion());
			}

			// VALIDAR PERSONAS BLOQUEADAS
			mensajeBean = validarListaPersonaBloq(depositosRefeBean);
			if(mensajeBean.getNumero() != 0){
				throw new Exception(mensajeBean.getDescripcion());
			}

		} catch (Exception e) {
			if(mensajeBean .getNumero()==0){
				mensajeBean .setNumero(999);
				mensajeBean.setDescripcion("Error en Proceso de Carga de Layout por ETL en depositos referenciados.");
			}
			mensajeBean.setDescripcion(e.getMessage());
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Proceso de Carga de Layout por ETL en depositos referenciados.", e);
		}

		return listaDep;
	}

	public List listaDepositosReferenciadosTMP(DepositosRefeBean depRefere, int tipoLista){
		List<?> listaDepRef = null;
		try{
			String query = "call TMPARCHIVOCARGADEPREFLIS(?,?,?,?,	?,?,?,?,?,?,?);";
			Object[] parametros = {
					Utileria.convierteEntero(depRefere.getInstitucionID()),
					depRefere.getNumCtaInstit(),
					Utileria.convierteLong(depRefere.getNumTransaccion()),
					tipoLista,

					parametrosAuditoriaBean.getEmpresaID(),
					parametrosAuditoriaBean.getUsuario(),
					parametrosAuditoriaBean.getFecha(),
					parametrosAuditoriaBean.getDireccionIP(),
					parametrosAuditoriaBean.getNombrePrograma(),
					parametrosAuditoriaBean.getSucursal(),
					Constantes.ENTERO_CERO
			};

			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TMPARCHIVOCARGADEPREFLIS(" + Arrays.toString(parametros).replace("[", "").replace("]", "") +");");

			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper<Object>() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

					DepositosRefeBean depRefereBean = new DepositosRefeBean();
					depRefereBean.setFolioCargaID(resultSet.getString("FolioCargaID"));
					depRefereBean.setNumCtaInstit(resultSet.getString("CuentaAhoID"));
					depRefereBean.setFechaOperacion(resultSet.getString("FechaOperacionArchivo"));
					depRefereBean.setReferenciaMov(resultSet.getString("ReferenciaMovArchivo"));
					depRefereBean.setMontoMov(resultSet.getString("MontoMov"));
					depRefereBean.setNatMovimiento(resultSet.getString("NatMovimientoArchivo"));
					depRefereBean.setDescripcionMov(resultSet.getString("DescripcionMovArchivo"));
					depRefereBean.setTipoMov(resultSet.getString("TipoMovArchivo"));
					depRefereBean.setTipoDeposito(resultSet.getString("TipoDepositoArchivo"));
					depRefereBean.setTipoMoneda(resultSet.getString("TipoMonedaArchivo"));
					depRefereBean.setTipoCanal(resultSet.getString("TipoCanalArchivo"));
					depRefereBean.setNumIdenArchivo(resultSet.getString("NumIdenArchivo"));
					depRefereBean.setNumTransaccion(resultSet.getString("NumTransaccion"));
					depRefereBean.setValidacion(resultSet.getString("Validacion"));
					depRefereBean.setNumVal(resultSet.getString("NumVal"));
					depRefereBean.setNumTran(resultSet.getString("NumTransaccionCarga"));
					depRefereBean.setNumeroFila(resultSet.getString("NumeroFila"));
					depRefereBean.setAplicarDeposito(resultSet.getString("AplicarDeposito"));
					depRefereBean.setNombreArchivoCarga(resultSet.getString("NombreArchivoCarga"));
					return depRefereBean;
				}
			});
			listaDepRef = matches;

		}catch(Exception exception){
			exception.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+" - "+"error en la lista de registros deposito referenciados temporal: ", exception);
		}

		return listaDepRef;
	}

	public MensajeTransaccionBean procesaCargaDepRef(final DepositosRefeBean depositosRefBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {

								String query = "call ARCHIVOCARGADEPREFPRO(?,?,?,?," +
														"?,?,?," +			// parametros de salida
														"?,?,?,?,?,?,?);"; 	// parametros auditoria

								CallableStatement sentenciaStore = arg0.prepareCall(query);

								sentenciaStore.setLong("Par_NumTran",Utileria.convierteLong(depositosRefBean.getNumTransaccion()));
								sentenciaStore.setInt("Par_InstitucionID",Utileria.convierteEntero(depositosRefBean.getInstitucionID()));
								sentenciaStore.setString("Par_NumCtaInstit",depositosRefBean.getNumCtaInstit());
								sentenciaStore.setString("Par_BancoEstandar",depositosRefBean.getBancoEstandar());

								//Parametros de Salida
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
									mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
									mensajeTransaccion.setDescripcion(resultadosStore.getString(2));
									mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
									mensajeTransaccion.setConsecutivoString(resultadosStore.getString(4));

								}else{
									mensajeTransaccion.setNumero(999);
									mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .DepositosRefeDAO.procesaCargaDepRef");
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
						throw new Exception(Constantes.MSG_ERROR + " .DepositosRefeDAO.procesaCargaDepRef");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en proceso de la carga de depositos referenciados" + e);
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


	public MensajeTransaccionBean validarListaPersonaBloq(DepositosRefeBean depositosRefeBean){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		List<?> listDepositosRefeBean = null;

		try {
			int tipoLista = 1;
			listDepositosRefeBean = listaDepositosReferenciadosTMP(depositosRefeBean, tipoLista);
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Numero de Registros: " + listDepositosRefeBean.size()+" - "+listDepositosRefeBean);

			if(listDepositosRefeBean!=null && listDepositosRefeBean.size() > 0){

				Iterator iterList = listDepositosRefeBean.iterator();
				DepositosRefeBean depRefe;

				while(iterList.hasNext()){

					depRefe = (DepositosRefeBean) iterList.next();

					// SOLO VALIDA PERSONAS BLOQUEADAS LOS QUE AUN SON EXITOSOS
					if(depRefe.getNumVal().equals("0")){

						/**
						 * TODOS LOS DATOS DE CARGA SON CORRECTOS SE REALIZA LA VALIDACION
						 * SI LA PERSONA
						 * SE ENCUENTRA EN LISTA DE PERSONAS BLOQUEADAS
						 */
						PLDListasPersBloqBean pldListasPersBloqBean = new PLDListasPersBloqBean();
						SeguimientoPersonaListaBean seguimientoPersonaListaBean = new SeguimientoPersonaListaBean();

						switch(Utileria.convierteEntero(depRefe.getTipoCanal())){
							case 1:

								/** Se arma bean auxiliar para consultar la referencia de pago por instrumento.**/
								DepositosRefeBean depAux1 = new DepositosRefeBean();
								depAux1.setInstitucionID(depRefe.getInstitucionID());
								depAux1.setReferenciaMov(depRefe.getReferenciaMov());
								depAux1.setTipoCanal(depRefe.getTipoCanal());

								ReferenciasPagosBean depositosAux1 = referenciasPagosDAO.consultaPrincipal(depAux1, 2);
								CreditosBean creditosBean = new CreditosBean();
								/** Se busca el número de cuenta si es que existe en la tabla de REFPAGOSXINST.**/
								if(depositosAux1.getExiste().equalsIgnoreCase("S")){

									creditosBean.setCreditoID(depositosAux1.getInstrumentoID());
								}else{
									creditosBean.setCreditoID(depRefe.getReferenciaMov());
								}

								creditosBean =	creditosDAO.consultaPrincipal(creditosBean, 1);

								if(creditosBean != null){

									pldListasPersBloqBean.setPersonaBloqID(creditosBean.getClienteID());
									pldListasPersBloqBean.setTipoPers("CTE");
									pldListasPersBloqBean.setCreditoID(creditosBean.getCreditoID());
								}else{
									pldListasPersBloqBean = null;
								}
							break;
							case 2:

								/** Se arma bean auxiliar para consultar la referencia de pago por instrumento.**/
								DepositosRefeBean depAux2 = new DepositosRefeBean();
								depAux2.setInstitucionID(depRefe.getInstitucionID());
								depAux2.setReferenciaMov(depRefe.getReferenciaMov());
								depAux2.setTipoCanal(depRefe.getTipoCanal());

								ReferenciasPagosBean depositosAux2 = referenciasPagosDAO.consultaPrincipal(depAux2, 1);
								CuentasAhoBean cuentasAhoBean = new CuentasAhoBean();
								/** Se busca el número de cuenta si es que existe en la tabla de REFPAGOSXINST.**/
								if(depositosAux2.getExiste().equalsIgnoreCase("S")){

									cuentasAhoBean.setCuentaAhoID(depositosAux2.getInstrumentoID());
								}else{
									cuentasAhoBean.setCuentaAhoID(depRefe.getReferenciaMov());
								}

								cuentasAhoBean = cuentasAhoDAO.consultaPrincipal(cuentasAhoBean, 1);
								if(cuentasAhoBean != null){
									pldListasPersBloqBean.setPersonaBloqID(cuentasAhoBean.getClienteID());
									pldListasPersBloqBean.setTipoPers("CTE");
									pldListasPersBloqBean.setCuentaAhoID(cuentasAhoBean.getCuentaAhoID());
								}else{
									pldListasPersBloqBean = null;
								}

							break;
							case 3:
									pldListasPersBloqBean.setPersonaBloqID(depRefe.getReferenciaMov());
									pldListasPersBloqBean.setTipoPers("CTE");
							break;

						}
						if(pldListasPersBloqBean!= null){
							PLDListasPersBloqBean listasPersBloqBean = pldListasPersBloqDAO.consultaEstaBloq(pldListasPersBloqBean, 2);
							seguimientoPersonaListaBean.setTipoLista(pldListasPersBloqBean.getTipoPers());
							seguimientoPersonaListaBean.setListaDeteccion("LPB");
							seguimientoPersonaListaBean.setNumRegistro(pldListasPersBloqBean.getPersonaBloqID());
							SeguimientoPersonaListaBean listaSeguimientoBean  = seguimientoPersonaListaDAO.consultaPermite(seguimientoPersonaListaBean, 2);
							if(listasPersBloqBean.getEstaBloqueado().equalsIgnoreCase("S") && listaSeguimientoBean.getPermiteOperacion().equalsIgnoreCase("N")){
								int numAct = 1;
								depRefe.setOpeInusualID(listaSeguimientoBean.getOpeInusualID());
								//CUANDO SE DETECTA UNA PERSONA BLOQUEADA SE ACTUALIZA EL REGISTRO EN LA TABLA TEMPORAL
								mensaje = actPersBloqLayout(depRefe, numAct);

								if(mensaje.getNumero()!=0){
									throw new Exception(mensaje.getDescripcion());
								}
							}
						}
						// FIN SECCION PARA DETECTAR PERSONAS BLOQUEDAS

					}

				}

			}else{
				mensaje.setNumero(1);
				throw new Exception("La lista de registros esta vacia");
			}

		}catch (Exception e) {
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en lista de depositos referenciados " + e);
			e.printStackTrace();
			if (mensaje.getNumero() == 0) {
				mensaje.setNumero(999);
			}
			mensaje.setDescripcion(e.getMessage());
		}

		return mensaje;
	}

	public MensajeTransaccionBean actPersBloqLayout(final DepositosRefeBean depositosRefBean, final int numAct) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {

								String query = "call TMPARCHIVOCARGADEPREFACT(?,?,?,?," +
														"?,?,?," +			// parametros de salida
														"?,?,?,?,?,?,?);"; 	// parametros auditoria

								CallableStatement sentenciaStore = arg0.prepareCall(query);

								sentenciaStore.setLong("Par_NumTran",Utileria.convierteLong(depositosRefBean.getNumTran()));
								sentenciaStore.setLong("Par_FolioCargaID",Utileria.convierteLong(depositosRefBean.getFolioCargaID()));
								sentenciaStore.setLong("Par_OpeInusualID",Utileria.convierteLong(depositosRefBean.getOpeInusualID()));
								sentenciaStore.setInt("Par_NumAct",numAct);

								//Parametros de Salida
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
									mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
									mensajeTransaccion.setDescripcion(resultadosStore.getString(2));
									mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
									mensajeTransaccion.setConsecutivoString(resultadosStore.getString(4));

								}else{
									mensajeTransaccion.setNumero(999);
									mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .DepositosRefeDAO.procesaCargaDepRef");
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
						throw new Exception(Constantes.MSG_ERROR + " .DepositosRefeDAO.procesaCargaDepRef");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en proceso de la carga de depositos referenciados" + e);
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

	/*METODO PARA CARGA DEL ARCHIVO ESTANDAR EN FORMATO XLS*/
	public ResultadoCargaArchivosTesoreriaBean cargaArchivoXLS(final String rutaArchivo, final DepositosRefeBean depositosRefeBean){
		ResultadoCargaArchivosTesoreriaBean resultado = new ResultadoCargaArchivosTesoreriaBean();

		resultado = (ResultadoCargaArchivosTesoreriaBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
				new TransactionCallback<Object>() {
					public Object doInTransaction(TransactionStatus transaction) {

						ResultadoCargaArchivosTesoreriaBean resultadoCarga =new ResultadoCargaArchivosTesoreriaBean();
						int tamanoLista=0;
						String motivoDescripcion = saltoLinea + "Archivo cargado exitosamente.";

						try{

							/**Cuando el usuario carga o vuelve a cargar el archivo se borran de la tabla temporal
							 * los datos que se cargaron anteriormente, por numero de transaccion*/

							List depositoReferenciado;
							long numeroTransaccion = transaccionDAO.generaNumeroTransaccionOut();
							depositosRefeBean.setNumTransaccion(numeroTransaccion+"");
							loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+numeroTransaccion+" Depositos Referenciados CargaLayoutExcel Estandar: "+depositosRefeBean.getCargaLayoutXLSDepRef());

							MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();

							try{
								depositosRefeBean.setTipoMoneda((depositosRefeBean.getTipoMoneda()== null)?"0":depositosRefeBean.getTipoMoneda());
								depositosRefeBean.setTipoCanal((depositosRefeBean.getTipoCanal()== null)?"":depositosRefeBean.getTipoCanal());

								// PARAMETROS PROCESOSETL
								ProcesosETLBean procesosETLBean = new ProcesosETLBean();
								procesosETLBean.setProcesoETLID("1");//id del proceso ETL TABLA PROCESOSETL

								// PARAMETROS PANTALLA
								String[] parametros = {
									numeroTransaccion+"", // "Par_TransaccionID",
									rutaArchivo, // "Par_RutaArchivoCarga",
									depositosRefeBean.getInstitucionID(),//  "Par_InstitucionID",
									depositosRefeBean.getNumCtaInstit(),// "Par_NumCtaInstit",
									depositosRefeBean.getBancoEstandar(),// "Par_BancoEstandar",
									depositosRefeBean.getFechaCargaInicial(),// "Par_FechaCargaInicial",
									depositosRefeBean.getFechaCargaFinal(), // "Par_FechaCargaFinal",
									depositosRefeBean.getTipoCanal(), // "Par_TipoCanal",
									depositosRefeBean.getTipoMoneda() // "Par_TipoMoneda",
								};

								// EJECUCION DEL SH QUE PROCESA EL ETL
								mensajeBean = procesosETLDAO.procesarArchivoSH(procesosETLBean, parametros);
								if(mensajeBean.getNumero() != 0){
									throw new Exception(mensajeBean.getDescripcion());
								}

								// VALIADA Y PROCESA LA INFORMACION
								mensajeBean = null;
								mensajeBean = procesaCargaDepRef(depositosRefeBean);
								if(mensajeBean.getNumero() != 0){
									throw new Exception(mensajeBean.getDescripcion());
								}

								// VALIDAR PERSONAS BLOQUEADAS
								mensajeBean = null;
								mensajeBean = validarListaPersonaBloq(depositosRefeBean);
								if(mensajeBean.getNumero() != 0){
									throw new Exception(mensajeBean.getDescripcion());
								}

							} catch (Exception e) {
								if(mensajeBean .getNumero()==0){
									mensajeBean .setNumero(999);
									mensajeBean.setDescripcion("Error en Proceso de Carga de Layout por ETL en depositos referenciados.");
								}
								mensajeBean.setDescripcion(e.getMessage());
								e.printStackTrace();
								loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Proceso de Carga de Layout por ETL en depositos referenciados.", e);
							}
// ---------------------------------------------------------------
							if(mensajeBean.getNumero() != 0){
								throw new Exception(mensajeBean.getDescripcion());
							}
							depositoReferenciado = listaDepositosReferenciadosTMP(depositosRefeBean, 1);

							if(depositoReferenciado!=null){
								tamanoLista= depositoReferenciado.size();

								Iterator <DepositosRefeBean> iterList = depositoReferenciado.iterator();
								int intitucionID = Utileria.convierteEntero(depositosRefeBean.getInstitucionID());

								DepositosRefeBean refeBean;
								if(depositoReferenciado!=null && depositoReferenciado.size() > 0){
									while(iterList.hasNext()){

										refeBean = (DepositosRefeBean) iterList.next();
										refeBean.setNumTranAnt(depositosRefeBean.getNumTranAnt());
										refeBean.setNumCtaInstit(depositosRefeBean.getNumCtaInstit());

										refeBean.setInstitucionID(depositosRefeBean.getInstitucionID());
										MensajeTransaccionBean mensaje=new MensajeTransaccionBean();
										mensaje = validaMensajeValTablaTmp(refeBean);
										refeBean.setTipoMoneda("1");

										if(mensaje.getNumero()==10){
											refeBean.setNumVal("15");
										}

										resultadoCarga = validaDeRef(refeBean, resultadoCarga, intitucionID, Enum_Tra_Inserta.grabaTabla,numeroTransaccion);

										if(resultadoCarga.getNumero()!=0){
											throw new Exception(resultadoCarga.getDescripcion());
										}
										resultadoCarga.setDescripcion("Total Registros:"+tamanoLista+motivoDescripcion);
									}
								}else{
									resultadoCarga.setNumero(999);
									resultadoCarga.setDescripcion("Asegurese de subir el archivo con el formato correcto.");
									throw new Exception(resultadoCarga.getDescripcion());
								}
							}else{
								resultadoCarga.setDescripcion("Asegurese de subir el archivo con el formato correcto.");
								throw new Exception(resultadoCarga.getDescripcion());
							}
						}catch(Exception e){
							e.printStackTrace();
							loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en carga de archivo", e);
							resultadoCarga.setConsecutivoInt("institucionID");
							resultadoCarga.setConsecutivoString("institucionID");
							resultadoCarga.setNumero(999);
							resultadoCarga.setDescripcion(e.getMessage());
							transaction.setRollbackOnly();
						}
						return resultadoCarga;
					}
				});
		return resultado;
	}

	public CuentasAhoDAO getCuentasAhoDAO() {
		return cuentasAhoDAO;
	}


	public void setCuentasAhoDAO(CuentasAhoDAO cuentasAhoDAO) {
		this.cuentasAhoDAO = cuentasAhoDAO;
	}


	public ReferenciasPagosDAO getReferenciasPagosDAO() {
		return referenciasPagosDAO;
	}


	public void setReferenciasPagosDAO(ReferenciasPagosDAO referenciasPagosDAO) {
		this.referenciasPagosDAO = referenciasPagosDAO;
	}
	public CreditosDAO getCreditosDAO() {
		return creditosDAO;
	}
	public void setCreditosDAO(CreditosDAO creditosDAO) {
		this.creditosDAO = creditosDAO;
	}
	public PLDListasPersBloqDAO getPldListasPersBloqDAO() {
		return pldListasPersBloqDAO;
	}
	public void setPldListasPersBloqDAO(PLDListasPersBloqDAO pldListasPersBloqDAO) {
		this.pldListasPersBloqDAO = pldListasPersBloqDAO;
	}
	public SeguimientoPersonaListaDAO getSeguimientoPersonaListaDAO() {
		return seguimientoPersonaListaDAO;
	}
	public void setSeguimientoPersonaListaDAO(
			SeguimientoPersonaListaDAO seguimientoPersonaListaDAO) {
		this.seguimientoPersonaListaDAO = seguimientoPersonaListaDAO;
	}
	public ProcesosETLDAO getProcesosETLDAO() {
		return procesosETLDAO;
	}
	public void setProcesosETLDAO(ProcesosETLDAO procesosETLDAO) {
		this.procesosETLDAO = procesosETLDAO;
	}



}