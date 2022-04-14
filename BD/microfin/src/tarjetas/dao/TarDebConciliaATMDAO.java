package tarjetas.dao;

import java.io.BufferedReader;
import java.io.FileReader;
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
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;

import tarjetas.bean.TarDebConciliaATMBean;
import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

public class TarDebConciliaATMDAO extends BaseDAO{

	public MensajeTransaccionBean altaConciliacionATM(final TarDebConciliaATMBean tarDebConciATMBean){
		MensajeTransaccionBean mensajeFinal = new MensajeTransaccionBean();
		mensajeFinal = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
				try {
					BufferedReader bufferedReader;
					String nombreArchivo = tarDebConciATMBean.getRuta();
					String renglon;
					int numConciliaID = 0;
					int i = 0;
					String numTransaccion = "";
					TarDebConciliaATMBean tarDebConciliaEncaBean = new TarDebConciliaATMBean();

					bufferedReader = new BufferedReader(new FileReader(nombreArchivo));
					if (bufferedReader != null ){
						while ((renglon = bufferedReader.readLine())!= null){
							if (i < 6){
								// Son renglos de encabezado
								if (renglon.contains("Codigo")){
									String codigo = renglon.trim();
									String auxCodigo[] = codigo.split(":");
									codigo = auxCodigo[1];
									tarDebConciliaEncaBean.setCodigo(codigo);
								}
								if (renglon.contains("Institucion")){
									String fecha = renglon.substring(179,  200);
									tarDebConciliaEncaBean.setFecha(fecha.trim());
								}
							}else if(i == 6){
								mensaje = altaEncabezaConcilia(tarDebConciliaEncaBean);
								if (mensaje.getNumero() != Constantes.ENTERO_CERO){
									throw new Exception(mensaje.getDescripcion());
								}else{
									numTransaccion = mensaje.getConsecutivoString();
									tarDebConciliaEncaBean.setConciliaATMID(String.valueOf(numTransaccion));
								}
							}
							if (i >= 6){
								TarDebConciliaATMBean tarDebConciliaDetBean = new TarDebConciliaATMBean();
								tarDebConciliaDetBean.setConciliaATMID(String.valueOf(numTransaccion));
								if(renglon.contains("Transacciones")){
									String numTransac = renglon.trim();
									String arrNumTran[] = numTransac.split(":");
									tarDebConciliaEncaBean.setTotalTransac(arrNumTran[1].trim());
									mensaje = actualizaEncaConcilia(tarDebConciliaEncaBean);
									if (mensaje.getNumero() != Constantes.ENTERO_CERO){
										throw new Exception(mensaje.getDescripcion());
									}
								}else{
									// Son renglones de detalle de registros
									tarDebConciliaDetBean.setEmisor(renglon.substring(2, 10));
									tarDebConciliaDetBean.setTerminalID(renglon.substring(24, 35));
									tarDebConciliaDetBean.setTarjetaDebID(renglon.substring(36, 52));
									tarDebConciliaDetBean.setCuentaOrigen(renglon.substring(59, 80));
									tarDebConciliaDetBean.setDescripcion(renglon.substring(102, 117));
									tarDebConciliaDetBean.setCodigoRespuesta(renglon.substring(126, 129));
									tarDebConciliaDetBean.setSecuencia(renglon.substring(132, 135));
									tarDebConciliaDetBean.setFechaTransac(renglon.substring(149, 157));
									tarDebConciliaDetBean.setHoraTransac(renglon.substring(158, 165));
									tarDebConciliaDetBean.setRed(renglon.substring(175, 179));
									tarDebConciliaDetBean.setMontoTransac(renglon.substring(180, 190));
									tarDebConciliaDetBean.setComision(renglon.substring(201, 208));
									tarDebConciliaDetBean.setNumAutorizacion(renglon.substring(226, 231));

									mensaje = altaDetalleConcilia(tarDebConciliaDetBean);
									if (mensaje.getNumero() != Constantes.ENTERO_CERO){
										throw new Exception(mensaje.getDescripcion());
									}
								}
							}
							i++;
						}
					}else{
						mensaje.setNumero(Integer.valueOf("004"));
						mensaje.setDescripcion("El archivo esta vacio.");
						throw new Exception(mensaje.getDescripcion());
					}
					mensaje.setNumero(Integer.valueOf("000"));
					mensaje.setDescripcion("Archivo de Conciliacion Procesado Correctamente.");
					bufferedReader.close();

				} catch (Exception e) {
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en leer archivo de tesoreria movimientos de conciliacion leeArchivoTesoMovsConcEstandar.");
					if(mensaje.getNumero()==0){
						mensaje.setNumero(999);
					}
					mensaje.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
				}
				return mensaje;
			}
		});
		return mensajeFinal;

	}




	/* Alta de Encabezado de Conciliacion Tarjetas ATM*/
	public MensajeTransaccionBean altaEncabezaConcilia(final TarDebConciliaATMBean conciliaEncabezaATMBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();

		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
				new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
				// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
							String query = "call TARDEBCONCIATMENCALT("
											+ "?,?,?,?,?,"
											+ "?,?,?,?,?,"
											+ "?,?);";//parametros de auditoria

							CallableStatement sentenciaStore = arg0.prepareCall(query);
							sentenciaStore.setString("Par_Fecha", conciliaEncabezaATMBean.getFecha());
							sentenciaStore.setString("Par_Codigo", conciliaEncabezaATMBean.getCodigo());
							sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
							sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
							sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
							//Parametros de Auditoria
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
								mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .TarDebConciliaATMDAO.altaDetallesConcilia");
								mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
								mensajeTransaccion.setConsecutivoString(Constantes.STRING_VACIO);
							}
							return mensajeTransaccion;
						}
					});
					if(mensajeBean ==  null){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception(Constantes.MSG_ERROR + " .TarDebConciliaATMDAO.altaDetallesConcilia");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en el Registro de Detalle de Conciliacion ATM " + e);
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

	/* Alta de Detalles Conciliacion Tarjetas*/
	public MensajeTransaccionBean altaDetalleConcilia(final TarDebConciliaATMBean conciliaDetalleATMBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();

		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
				new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call TARDEBCONCIATMDETALT("
													+ "?,?,?,?,?,"
													+ "?,?,?,?,?,"
													+ "?,?,?,?,?,"
													+ "?,?,?,?,?,"
													+ "?,?,?,?);";//parametros de auditoria

									CallableStatement sentenciaStore = arg0.prepareCall(query);
									sentenciaStore.setString("Par_ConciliaATM", conciliaDetalleATMBean.getConciliaATMID());
									sentenciaStore.setString("Par_Emisor", conciliaDetalleATMBean.getEmisor());
									sentenciaStore.setString("Par_TerminalID", conciliaDetalleATMBean.getTerminalID());
									sentenciaStore.setString("Par_TarjetaDebID", conciliaDetalleATMBean.getTarjetaDebID());
									sentenciaStore.setString("Par_CuentaOrigen", conciliaDetalleATMBean.getCuentaOrigen());

									sentenciaStore.setString("Par_Descripcion", conciliaDetalleATMBean.getDescripcion());
									sentenciaStore.setString("Par_CodigoRespuesta", conciliaDetalleATMBean.getCodigoRespuesta());
									sentenciaStore.setString("Par_Secuencia", conciliaDetalleATMBean.getSecuencia());
									sentenciaStore.setString("Par_FechaTransac", conciliaDetalleATMBean.getFechaTransac());
									sentenciaStore.setString("Par_HoraTransac", conciliaDetalleATMBean.getHoraTransac());

									sentenciaStore.setString("Par_Red", conciliaDetalleATMBean.getRed());
									sentenciaStore.setString("Par_MontoTransac", conciliaDetalleATMBean.getMontoTransac());
									sentenciaStore.setString("Par_Comision", conciliaDetalleATMBean.getComision());
									sentenciaStore.setString("Par_NumAutorizacion", conciliaDetalleATMBean.getNumAutorizacion());
									sentenciaStore.setString("Par_Salida",Constantes.salidaSI);

									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

									//Parametros de Auditoria
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
										mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
										mensajeTransaccion.setDescripcion(resultadosStore.getString(2));
										mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
										mensajeTransaccion.setConsecutivoString(resultadosStore.getString(4));

									}else{
										mensajeTransaccion.setNumero(999);
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .TarDebConciliaATMDAO.altaDetallesConcilia");
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
							throw new Exception(Constantes.MSG_ERROR + " .TarDebConciliaATMDAO.altaDetallesConcilia");
						}else if(mensajeBean.getNumero()!=0){
							throw new Exception(mensajeBean.getDescripcion());
						}
					} catch (Exception e) {
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en el Registro de Detalle de Conciliacion ATM " + e);
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


	public MensajeTransaccionBean actualizaEncaConcilia(final TarDebConciliaATMBean conciliaEncabezaATMBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();

		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
				new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
				// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
							String query = "call TARDEBCONCIATMENCACT("
											+ "?,?,?,?,?,"
											+ "?,?,?,?,?,"
											+ "?,?,?,?);";//parametros de auditoria

							CallableStatement sentenciaStore = arg0.prepareCall(query);
							sentenciaStore.setInt("Par_ConciliaATMID",Utileria.convierteEntero(conciliaEncabezaATMBean.getConciliaATMID()));
							sentenciaStore.setString("Par_Fecha", conciliaEncabezaATMBean.getFecha());
							sentenciaStore.setString("Par_Codigo", conciliaEncabezaATMBean.getCodigo());
							sentenciaStore.setInt("Par_TotalTransac", Utileria.convierteEntero(conciliaEncabezaATMBean.getTotalTransac()));

							sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
							sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
							sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
							//Parametros de Auditoria
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
								mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .TarDebConciliaATMDAO.altaDetallesConcilia");
								mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
								mensajeTransaccion.setConsecutivoString(Constantes.STRING_VACIO);
							}
							return mensajeTransaccion;
						}
					});
					if(mensajeBean ==  null){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception(Constantes.MSG_ERROR + " .TarDebConciliaATMDAO.altaDetallesConcilia");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en la Actualizacion de Detalle de Conciliacion ATM " + e);
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

}
