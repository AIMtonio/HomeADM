package tarjetas.dao;

import general.bean.MensajeTransaccionArchivoBean;
import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.List;

import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.CallableStatementCallback;
import org.springframework.jdbc.core.CallableStatementCreator;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;
import org.springframework.transaction.support.TransactionTemplate;

import regulatorios.bean.RegulatorioA1713Bean;
import tarjetas.bean.CargaArchivosTarjetaBean;
import tarjetas.bean.TarjetaCreditoBean;


public class CargaArchivosTarjetaDAO extends BaseDAO{

	public CargaArchivosTarjetaDAO() {
		super();
	}

	TarjetaCreditoBean pagoTarjetaBean = null;

	// CARGA DEL NOMBRE DEL ARCHIVO
		public MensajeTransaccionArchivoBean cargaTituloArchivo(final int tipoTransaccion, final CargaArchivosTarjetaBean  cargaArchivosTarjetaBean) {
			MensajeTransaccionArchivoBean mensaje = new MensajeTransaccionArchivoBean();
			transaccionDAO.generaNumeroTransaccion();
			mensaje = (MensajeTransaccionArchivoBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
				public Object doInTransaction(TransactionStatus transaction) {
					MensajeTransaccionArchivoBean mensajeBean = new MensajeTransaccionArchivoBean();
					try {
						// Query con el Store Procedure


				mensajeBean = (MensajeTransaccionArchivoBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call TC_ARCHIVOTRANSACCIONALT(?,?,?,?,?,       ?,?,?,?,?,    ?,?,?,?);";

									CallableStatement sentenciaStore = arg0.prepareCall(query);
									sentenciaStore.setString("Par_FechaCarga",cargaArchivosTarjetaBean.getFechaCarga());
									sentenciaStore.setString("Par_NombreArchivo",cargaArchivosTarjetaBean.getNombreArchivo());
									sentenciaStore.setString("Par_TipoArchivo",cargaArchivosTarjetaBean.getTipoArchivo());
									sentenciaStore.setString("Par_TipoCarga",cargaArchivosTarjetaBean.getTipoCarga());

									sentenciaStore.setString("Par_Salida",	Constantes.salidaSI);
									// Parametros de OutPut
									sentenciaStore.registerOutParameter("Par_NumErr",Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen",Types.VARCHAR);

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
									MensajeTransaccionArchivoBean mensajeTransaccion = new MensajeTransaccionArchivoBean();
									if(callableStatement.execute()){

										ResultSet resultadosStore = callableStatement.getResultSet();

										resultadosStore.next();
										mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
										mensajeTransaccion.setDescripcion(resultadosStore.getString(2));
										mensajeTransaccion.setConsecutivoString(String.valueOf(parametrosAuditoriaBean.getNumeroTransaccion()));
									}else{
										mensajeTransaccion.setNumero(999);
										mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.");
									}

									return mensajeTransaccion;
								}
							}
							);

						if(mensajeBean ==  null){
							mensajeBean = new MensajeTransaccionArchivoBean();
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
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta del archivo de operaciones", e);
						mensajeBean.setDescripcion(e.getMessage());
						transaction.setRollbackOnly();
					}
					return mensajeBean;
				}
			});
			return mensaje;
		}

		// CARGA DE LINEAS DEL ARCHIVO
				public MensajeTransaccionBean cargaLineasArchivo(final int tipoTransaccion, final CargaArchivosTarjetaBean  cargaArchivosTarjetaBean) {
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
											String query = "call TC_ARCHTRANSTEMPALT(?,?,?,?,?,       ?,?,?,?,?,    ?,?);";

											CallableStatement sentenciaStore = arg0.prepareCall(query);
											sentenciaStore.setInt("Par_Transaccion",cargaArchivosTarjetaBean.getNumTransaccion());
											sentenciaStore.setString("Par_Contenido",cargaArchivosTarjetaBean.getContenido());

											sentenciaStore.setString("Par_Salida",	Constantes.salidaSI);
											// Parametros de OutPut
											sentenciaStore.registerOutParameter("Par_NumErr",Types.INTEGER);
											sentenciaStore.registerOutParameter("Par_ErrMen",Types.VARCHAR);

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



				// PROCESA REGISTROS DE ARCHIVO
				public MensajeTransaccionBean procesaRegistro(final int tipoTransaccion, final CargaArchivosTarjetaBean  cargaArchivosTarjetaBean) {
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
											String query = "call TC_PROCESAREGISTROSPRO(?,?,?,?,?,       ?,?,?,?,?,    ?);";

											CallableStatement sentenciaStore = arg0.prepareCall(query);
											sentenciaStore.setInt("Par_Transaccion",cargaArchivosTarjetaBean.getNumTransaccion());

											sentenciaStore.setString("Par_Salida",	Constantes.salidaSI);
											// Parametros de OutPut
											sentenciaStore.registerOutParameter("Par_NumErr",Types.INTEGER);
											sentenciaStore.registerOutParameter("Par_ErrMen",Types.VARCHAR);

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
												mensajeTransaccion.setNombreControl(String.valueOf(resultadosStore.getString(3)));
												mensajeTransaccion.setConsecutivoString(String.valueOf(resultadosStore.getString(4)));
												mensajeTransaccion.setConsecutivoInt(String.valueOf(resultadosStore.getString(5)));

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
								e.printStackTrace();
								loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en proceso de tarjetas de credito", e);
								mensajeBean.setDescripcion(e.getMessage());
								transaction.setRollbackOnly();
							}
							return mensajeBean;
						}
					});
					return mensaje;
				}

				public MensajeTransaccionBean aplicaPagosLinCred(final List listaPagos) {
					MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
					transaccionDAO.generaNumeroTransaccion();

					mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
						public Object doInTransaction(TransactionStatus transaction) {
							MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
							try {


								if(listaPagos!=null){
									for(int i=0; i<listaPagos.size(); i++){
										pagoTarjetaBean = (TarjetaCreditoBean)listaPagos.get(i);
										mensajeBean = procesaRegistroPago(pagoTarjetaBean);
										if(mensajeBean.getNumero()!=0){
											throw new Exception(mensajeBean.getDescripcion());
										}
									}
								}

								mensajeBean = new MensajeTransaccionBean();
								mensajeBean.setNumero(0);
								mensajeBean.setDescripcion("Operación Realizada Exitosamente");
								mensajeBean.setNombreControl("archivo");
								mensajeBean.setConsecutivoInt(Constantes.STRING_CERO);


							} catch (Exception e) {
								e.printStackTrace();
								loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error al registrar el Pago de Tarjeta de Crédito", e);
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


				public MensajeTransaccionBean procesaRegistroPago(final TarjetaCreditoBean  tarjetaCreditoBean) {
					MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
					mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
						public Object doInTransaction(TransactionStatus transaction) {
							MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
							try {
								// Query con el Store Procedure


						mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
									new CallableStatementCreator() {
										public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
											String query = "call TC_PAGOLINEAPRO(?,?,?,?,?,   ?,?,?,?,?,   ?,?,?,?,?,  ?,?,?,?,?,  ?,?,?,? );";

											CallableStatement sentenciaStore = arg0.prepareCall(query);

											sentenciaStore.setString("Par_NumeroTarjeta",	Constantes.STRING_VACIO);
											sentenciaStore.setString("Par_CuentaClabe",	tarjetaCreditoBean.getClabe());
											sentenciaStore.setString("Par_Referencia",	tarjetaCreditoBean.getAlias());
											sentenciaStore.setDouble("Par_MontoTransaccion", Utileria.convierteDoble(tarjetaCreditoBean.getCantidad()));
											sentenciaStore.setString("Par_MonedaID", "1");

											sentenciaStore.setString("Par_NumTransaccion",	tarjetaCreditoBean.getNumTransaccion());
											sentenciaStore.setString("Par_FechaActual",	tarjetaCreditoBean.getFecha());
											sentenciaStore.registerOutParameter("Par_NumeroTransaccion",Types.BIGINT);
											sentenciaStore.registerOutParameter("Par_SaldoContableAct",Types.DECIMAL);
											sentenciaStore.registerOutParameter("Par_SaldoDisponibleAct",Types.DECIMAL);

											sentenciaStore.registerOutParameter("Par_CodigoRespuesta",Types.VARCHAR);
											sentenciaStore.registerOutParameter("Par_FechaAplicacion",Types.DATE);
											sentenciaStore.setString("Var_TarCredMovID", "0");
											sentenciaStore.setString("Par_OrigenPago", "P");
											sentenciaStore.setString("Par_Salida",	Constantes.salidaSI);

											// Parametros de OutPut
											sentenciaStore.registerOutParameter("Par_NumErr",Types.INTEGER);
											sentenciaStore.registerOutParameter("Par_ErrMen",Types.VARCHAR);
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
												mensajeTransaccion.setNombreControl(String.valueOf(resultadosStore.getString(3)));

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
								e.printStackTrace();
								loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en la aplicación del pago de linea de credito", e);
								mensajeBean.setDescripcion(e.getMessage());
								transaction.setRollbackOnly();
							}
							return mensajeBean;
						}
					});
					return mensaje;
				}

}
