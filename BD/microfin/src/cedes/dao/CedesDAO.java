package cedes.dao;

import general.bean.MensajeTransaccionBean;
import general.bean.ParametrosSesionBean;
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
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;
import org.springframework.transaction.support.TransactionTemplate;

import cliente.bean.OperacionesCapitalNetoBean;
import cliente.dao.OperacionesCapitalNetoDAO;
import tesoreria.bean.CancelaChequesBean;
import cedes.bean.CedesBean;
import contabilidad.bean.PolizaBean;
import contabilidad.dao.PolizaDAO;

public class CedesDAO extends BaseDAO{
	ParametrosSesionBean parametrosSesionBean;
	PolizaDAO polizaDAO = null;
	PolizaBean polizaBean;
	OperacionesCapitalNetoDAO operacionesCapitalNetoDAO	= null;
	OperacionesCapitalNetoBean operCapitalNeto  = new OperacionesCapitalNetoBean();
	private final static String salidaPantalla = "S";

	public CedesDAO() {
		super();
	}

	/*Alta de CEDE*/

	public MensajeTransaccionBean alta(final CedesBean cedesBean,final int tipoTransaccion) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
					if (cedesBean.getTasaFija()== null){
						cedesBean.setTasaFija(Constantes.STRING_CERO);
					}
					if (cedesBean.getTasaISR()== null){
						cedesBean.setTasaISR(Constantes.STRING_CERO );
					}
					if (cedesBean.getTasaNeta()== null){
						cedesBean.setTasaNeta(Constantes.STRING_CERO );
					}
					if (cedesBean.getInteresGenerado()== null){
						cedesBean.setInteresGenerado(Constantes.STRING_CERO );
					}
					if (cedesBean.getInteresRecibir()== null){
						cedesBean.setInteresRecibir(Constantes.STRING_CERO );
					}
					if (cedesBean.getInteresRetener()== null){
						cedesBean.setInteresRetener(Constantes.STRING_CERO );
					}
			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call CEDESALT(?,?,?,?,?,	?,?,?,?,?,"
											   				   + "?,?,?,?,?,	?,?,?,?,?,"
											   				   + "?,?,?,?,?,	?,?,?,?,?,"
											   				   + "?,?,?,?,?,?,	?,?,?,?,?,?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);

									sentenciaStore.setInt("Par_TipoCedeID",Utileria.convierteEntero(cedesBean.getTipoCedeID()));
									sentenciaStore.setLong("Par_CuentaAhoID",Utileria.convierteLong(cedesBean.getCuentaAhoID()));
									sentenciaStore.setInt("Par_ClienteID",Utileria.convierteEntero(cedesBean.getClienteID()));
									sentenciaStore.setString("Par_FechaInicio",Utileria.convierteFecha(cedesBean.getFechaInicio()));
									sentenciaStore.setString("Par_FechaVencimiento",Utileria.convierteFecha(cedesBean.getFechaVencimiento()));

									sentenciaStore.setDouble("Par_Monto",Utileria.convierteDoble(cedesBean.getMonto()));
									sentenciaStore.setInt("Par_Plazo",Utileria.convierteEntero(cedesBean.getPlazo()));
									sentenciaStore.setDouble("Par_TasaFija",Utileria.convierteDoble(cedesBean.getTasaFija()));
									sentenciaStore.setDouble("Par_TasaISR",Utileria.convierteDoble(cedesBean.getTasaISR()));
									sentenciaStore.setDouble("Par_TasaNeta",Utileria.convierteDoble(cedesBean.getTasaNeta()));

									sentenciaStore.setDouble("Par_InteresGenerado",Utileria.convierteDoble(cedesBean.getInteresGenerado()));
									sentenciaStore.setDouble("Par_InteresRecibir",Utileria.convierteDoble(cedesBean.getInteresRecibir()));
									sentenciaStore.setDouble("Par_InteresRetener",Utileria.convierteDoble(cedesBean.getInteresRetener()));
									sentenciaStore.setDouble("Par_SaldoProvision",Utileria.convierteDoble(cedesBean.getSaldoProvision()));
									sentenciaStore.setDouble("Par_ValorGat",Utileria.convierteDoble(cedesBean.getValorGat()));

									sentenciaStore.setDouble("Par_ValorGatReal",Utileria.convierteDoble(cedesBean.getValorGatReal()));
									sentenciaStore.setInt("Par_MonedaID",Utileria.convierteEntero(cedesBean.getMonedaID()));
									sentenciaStore.setString("Par_FechaVenAnt",Utileria.convierteFecha(cedesBean.getFechaVenAnt()));
									sentenciaStore.setString("Par_TipoPagoInt", cedesBean.getTipoPagoInt());
									sentenciaStore.setInt("Par_DiasPeriodo", Utileria.convierteEntero(cedesBean.getDiasPeriodo()));

									sentenciaStore.setString("Par_PagoIntCal", cedesBean.getPagoIntCal());
									sentenciaStore.setDouble("Par_CalculoInteres", Utileria.convierteDoble(cedesBean.getCalculoInteres()));
									sentenciaStore.setInt("Par_TasaBaseID",Utileria.convierteEntero( cedesBean.getTasaBaseID()));
									sentenciaStore.setDouble("Par_SobreTasa",Utileria.convierteDoble(cedesBean.getSobreTasa()));
									sentenciaStore.setDouble("Par_PisoTasa", Utileria.convierteDoble(cedesBean.getPisoTasa()));

									sentenciaStore.setDouble("Par_TechoTasa", Utileria.convierteDoble(cedesBean.getTechoTasa()));
									sentenciaStore.setInt("Par_ProductoSAFI", Utileria.convierteEntero(cedesBean.getProductoSAFI()));
									sentenciaStore.setString("Par_Reinversion", cedesBean.getReinversion());
									sentenciaStore.setString("Par_Reinvertir", cedesBean.getReinvertir());
									sentenciaStore.setInt("Par_TipoAlta",1);

									sentenciaStore.setString("Par_CajaRetiro",cedesBean.getCajaRetiro());
									sentenciaStore.setInt("Par_PlazoOriginal",Utileria.convierteEntero(cedesBean.getPlazoOriginal()));

									sentenciaStore.registerOutParameter("Par_CedeID", Types.INTEGER);
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

									loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CEDESALT "+ sentenciaStore.toString());
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
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .CedesDAO.alta");
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
							throw new Exception(Constantes.MSG_ERROR + " .CedesDAO.alta");
						}else if(mensajeBean.getNumero()!=0){
							throw new Exception(mensajeBean.getDescripcion());
						}
					} catch (Exception e) {
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en alta de Cede" + e);
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


	/* Modificar cede*/
	public MensajeTransaccionBean modificar(final CedesBean cedesBean,final int tipoTransaccion) {
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
									String query = "call CEDESMOD(" +
											"?,?,?,?,?,       " +
											"?,?,?,?,?,       " +
											"?,?,?,?,?,       " +
											"?,?,?,?,?,       " +
											"?,?,?,?,?,       " +
											"?,?,?,?,?,       " +
											"?,?,?,?,?,       	  " +
											"?,?,?,?,?,?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);

									sentenciaStore.setInt("Par_CedeID",Utileria.convierteEntero(cedesBean.getCedeID()));
									sentenciaStore.setInt("Par_TipoCedeID",Utileria.convierteEntero(cedesBean.getTipoCedeID()));
									sentenciaStore.setLong("Par_CuentaAhoID",Utileria.convierteLong(cedesBean.getCuentaAhoID()));
									sentenciaStore.setInt("Par_ClienteID",Utileria.convierteEntero(cedesBean.getClienteID()));
									sentenciaStore.setString("Par_FechaInicio",Utileria.convierteFecha(cedesBean.getFechaInicio()));

									sentenciaStore.setString("Par_FechaVencimiento",Utileria.convierteFecha(cedesBean.getFechaVencimiento()));
									sentenciaStore.setDouble("Par_Monto",Utileria.convierteDoble(cedesBean.getMonto()));
									sentenciaStore.setInt("Par_Plazo",Utileria.convierteEntero(cedesBean.getPlazo()));
									sentenciaStore.setDouble("Par_TasaFija",Utileria.convierteDoble(cedesBean.getTasaFija()));
									sentenciaStore.setDouble("Par_TasaISR",Utileria.convierteDoble(cedesBean.getTasaISR()));

									sentenciaStore.setDouble("Par_TasaNeta",Utileria.convierteDoble(cedesBean.getTasaNeta()));
									sentenciaStore.setDouble("Par_InteresGenerado",Utileria.convierteDoble(cedesBean.getInteresGenerado()));
									sentenciaStore.setDouble("Par_InteresRecibir",Utileria.convierteDoble(cedesBean.getInteresRecibir()));
									sentenciaStore.setDouble("Par_InteresRetener",Utileria.convierteDoble(cedesBean.getInteresRetener()));
									sentenciaStore.setDouble("Par_SaldoProvision",Utileria.convierteDoble(cedesBean.getSaldoProvision()));

									sentenciaStore.setDouble("Par_ValorGat",Utileria.convierteDoble(cedesBean.getValorGat()));
									sentenciaStore.setDouble("Par_ValorGatReal",Utileria.convierteDoble(cedesBean.getValorGatReal()));
									sentenciaStore.setInt("Par_MonedaID",Utileria.convierteEntero(cedesBean.getMonedaID()));
									sentenciaStore.setString("Par_FechaVenAnt",Utileria.convierteFecha(cedesBean.getFechaVenAnt()));
									sentenciaStore.setString("Par_TipoPagoInt" ,cedesBean.getTipoPagoInt());

									sentenciaStore.setInt("Par_DiasPeriodo", Utileria.convierteEntero(cedesBean.getDiasPeriodo()));
									sentenciaStore.setString("Par_PagoIntCal", cedesBean.getPagoIntCal());
									sentenciaStore.setDouble("Par_CalculoInteres", Utileria.convierteDoble(cedesBean.getCalculoInteres()));
									sentenciaStore.setInt("Par_TasaBaseID",Utileria.convierteEntero( cedesBean.getTasaBaseID()));
									sentenciaStore.setDouble("Par_SobreTasa",Utileria.convierteDoble(cedesBean.getSobreTasa()));

									sentenciaStore.setDouble("Par_PisoTasa", Utileria.convierteDoble(cedesBean.getPisoTasa()));
									sentenciaStore.setDouble("Par_TechoTasa", Utileria.convierteDoble(cedesBean.getTechoTasa()));
									sentenciaStore.setInt("Par_ProductoSAFI", Utileria.convierteEntero(cedesBean.getProductoSAFI()));
									sentenciaStore.setInt("Par_PlazoOriginal",Utileria.convierteEntero(cedesBean.getPlazoOriginal()));
									sentenciaStore.setString("Par_Reinversion", cedesBean.getReinversion());

									sentenciaStore.setString("Par_Reinvertir", cedesBean.getReinvertir());
									sentenciaStore.setString("Par_CajaRetiro",cedesBean.getCajaRetiro());

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

									loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CEDESMOD "+ sentenciaStore.toString());
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
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .CedesDAO.modificar");
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
							throw new Exception(Constantes.MSG_ERROR + " .CedesDAO.modificar");
						}else if(mensajeBean.getNumero()!=0){
							throw new Exception(mensajeBean.getDescripcion());
						}
					} catch (Exception e) {
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en modificacion de Cede" + e);
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

	/* Autorizacion de la cede*/
	public MensajeTransaccionBean autoriza(final CedesBean cedesBean, final int tipoTransaccion) {
	  MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
	  try{
		transaccionDAO.generaNumeroTransaccion();

		// GENERANDO POLIZA CONTABLE
				// -----------------------------------------------------------------
				polizaBean = new PolizaBean();
				cedesBean.setPolizaID("0");
				if (tipoTransaccion == 3 || tipoTransaccion == 5) { // 3 AUTORIZA CEDE
																	// //5 ANCLAJE
					polizaBean.setConceptoID(cedesBean.conceptoMovCEDES);
					polizaBean.setConcepto(cedesBean.descripcionMovCEDES);
					int contador = 0;
					/* Llamando al SP de Validacion*/
					mensaje=validaCede(cedesBean);
					if(mensaje.getNumero() == 0 && tipoTransaccion == 3) {
						operCapitalNeto = new OperacionesCapitalNetoBean();

						operCapitalNeto.setInstrumentoID(cedesBean.getCedeID());
						operCapitalNeto.setMontoMov(0.0);
						operCapitalNeto.setOrigenOperacion("C");
						operCapitalNeto.setPantallaOrigen("AC");

						mensaje = operacionesCapitalNetoDAO.evaluaProcesoOperCapital(operCapitalNeto);
					}

					if(mensaje.getNumero()==0){
						while (contador <= PolizaBean.numIntentosGeneraPoliza) {
							contador++;
							polizaDAO.generaPolizaIDGenerico(polizaBean, parametrosAuditoriaBean.getNumeroTransaccion());
							if (Utileria.convierteEntero(polizaBean.getPolizaID()) > 0) {
								break;
							}
						}
					}else {
						return mensaje;
					}

				}
				// FIN GENERACION POLIZA
				if(Utileria.convierteEntero(polizaBean.getPolizaID()) != 0){
					mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
						public Object doInTransaction(TransactionStatus transaction) {
							MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
							String numeroPoliza = polizaBean.getPolizaID();

							try {
								cedesBean.setPolizaID(numeroPoliza);
								mensajeBean = autorizaCede(cedesBean, tipoTransaccion);

								if(mensajeBean.getNumero() != 0){
									throw new Exception(mensajeBean.getDescripcion());
								}
							} catch (Exception e) {
								if (mensajeBean.getNumero() == 0) {
									mensajeBean.setNumero(999);
								}
								mensajeBean.setDescripcion(e.getMessage());
								transaction.setRollbackOnly();
								e.printStackTrace();
								loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "Error en autorización de cede", e);
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
							bajaPolizaBean.setDescProceso("CedesDAO.autoriza");
							bajaPolizaBean.setPolizaID(cedesBean.getPolizaID());
							MensajeTransaccionBean mensajeBaja = new MensajeTransaccionBean();
							mensajeBaja = polizaDAO.bajaPoliza(bajaPolizaBean);
							loggerSAFI.error(" Numero Error:" + mensajeBaja.getNumero() + " Mensaje: " + mensajeBaja.getDescripcion());
						} catch (Exception ex) {
							ex.printStackTrace();
						}
					}
					/* Fin Baja de la Poliza Contable*/
				}else{
					mensaje.setNumero(999);
					mensaje.setDescripcion("El Número de Póliza se encuentra Vacio");
					mensaje.setNombreControl("numeroTransaccion");
					mensaje.setConsecutivoString("0");
				}


			}catch(Exception ex){
				mensaje.setNumero(999);
				mensaje.setDescripcion("Error al Realizar Autorización de Cede.");
				ex.printStackTrace();
			}
	  return mensaje;
	  }

	/* Actualizacion de Estatus Impresion cede*/
	public MensajeTransaccionBean actualizaCede(final CedesBean cedesBean, final int tipoTransaccion) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		// GENERANDO POLIZA CONTABLE
		// -----------------------------------------------------------------
		polizaBean = new PolizaBean();
		cedesBean.setPolizaID("0");
		if (tipoTransaccion == 3 || tipoTransaccion == 5) { // 3 AUTORIZA CEDE
															// //5 ANCLAJE
			polizaBean.setConceptoID(cedesBean.conceptoMovCEDES);
			polizaBean.setConcepto(cedesBean.descripcionMovCEDES);
			int contador = 0;
			while (contador <= PolizaBean.numIntentosGeneraPoliza) {
				contador++;
				polizaDAO.generaPolizaIDGenerico(polizaBean, parametrosAuditoriaBean.getNumeroTransaccion());
				if (Utileria.convierteEntero(polizaBean.getPolizaID()) > 0) {
					break;
				}
			}
		}
		// FIN GENERACION POLIZA
		return mensaje;
	}

	public MensajeTransaccionBean cancelaCede(final CedesBean cedesBean, final int tipoTransaccion) {
		  MensajeTransaccionBean mensaje = new MensajeTransaccionBean();

			// GENERANDO POLIZA CONTABLE
					// -----------------------------------------------------------------
				polizaBean = new PolizaBean();
				cedesBean.setPolizaID("0");
				String estado = cedesBean.getEstatus();

					if (tipoTransaccion == 10) { // 10 cancela  CEDE
						if(estado.compareTo("A") != 0){
						polizaBean.setConceptoID(cedesBean.conceptoCancelaCEDES);
						polizaBean.setConcepto(cedesBean.descripcionMovCanCEDES);
						int contador = 0;
						while (contador <= PolizaBean.numIntentosGeneraPoliza) {
							contador++;
							mensaje = polizaDAO.generaPolizaIDGenerico(polizaBean, parametrosAuditoriaBean.getNumeroTransaccion());
							if (Utileria.convierteEntero(polizaBean.getPolizaID()) > 0) {
								break;
							}
							}

						}else{
							mensaje = actualizarCedes(cedesBean, tipoTransaccion);
						}


					}else if (tipoTransaccion == 11) { // 11 VENCIMIENTO ANTICIPADO DE CEDES

						polizaBean.setConceptoID(cedesBean.concVenAntCede);
						polizaBean.setConcepto(cedesBean.descVenAntCede);
						int contador = 0;
						while (contador <= PolizaBean.numIntentosGeneraPoliza) {
							contador++;
							mensaje =	polizaDAO.generaPolizaIDGenerico(polizaBean, parametrosAuditoriaBean.getNumeroTransaccion());
							if (Utileria.convierteEntero(polizaBean.getPolizaID()) > 0) {
								break;
							}
						}
					}
					if(estado.compareTo("A") != 0){
						if(Utileria.convierteEntero(polizaBean.getPolizaID()) != 0  ){

							cedesBean.setPolizaID(polizaBean.getPolizaID());
							// actualizar estatus de poliza
							mensaje = actualizarCedes(cedesBean, tipoTransaccion);

							if(mensaje.getNumero() != 0){
								PolizaBean bajaPolizaBean = new PolizaBean();
								bajaPolizaBean.setTipo(PolizaDAO.Enum_TipoBajaPoliza.bajaPolizaId);
								bajaPolizaBean.setNumTransaccion(String.valueOf(Constantes.ENTERO_CERO));
								bajaPolizaBean.setPolizaID(cedesBean.getPolizaID());
								polizaDAO.bajaPoliza(bajaPolizaBean);

							}

						}else{
							mensaje.setNumero(999);
							mensaje.setDescripcion("El Número de Póliza se encuentra Vacio");
							mensaje.setNombreControl("tipoOperacion");
							mensaje.setConsecutivoString("0");
						}
				}
			return mensaje;
		}


		/* Actualizar estatus a cancelado*/
		public MensajeTransaccionBean actualizarCedes(final CedesBean cedesBean,final int tipoTransaccion) {
			MensajeTransaccionBean mensaje = new MensajeTransaccionBean();

			mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
				public Object doInTransaction(TransactionStatus transaction) {
					MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
					try {
						// Query con el Store Procedure
				mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call CEDESACT(?,?,?,?, ?,?,?, ?,?,?,?,?,?,?);";

									CallableStatement sentenciaStore = arg0.prepareCall(query);
									sentenciaStore.setInt("Par_CedeID", Utileria.convierteEntero(cedesBean.getCedeID()));
									sentenciaStore.setInt("Par_ProductoSAFI", Utileria.convierteEntero(cedesBean.getProductoSAFI()));
									sentenciaStore.setInt("Par_NumAct",tipoTransaccion);

									sentenciaStore.setLong("Par_PolizaID", Utileria.convierteLong((cedesBean.getPolizaID())));
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
											mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .CedesDAO.cancelar");
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
								throw new Exception(Constantes.MSG_ERROR + " .CedesDAO.modificar");
							}else if(mensajeBean.getNumero()!=0){
								throw new Exception(mensajeBean.getDescripcion());
							}
						} catch (Exception e) {
							loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en actualizacion de estatus de Cede" + e);
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

	public MensajeTransaccionBean autorizaCede(final CedesBean cedesBean, final int tipoTransaccion) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
				// Query con el Store Procedure
			mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
					new TransactionCallback<Object>() {
						public Object doInTransaction(TransactionStatus transaction) {
							MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
								try {
									// Query con el Store Procedure
									mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
											new CallableStatementCreator() {
												public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
													String query = "call CEDESACT(?,?,?,?, ?,?,?, ?,?,?,?,?,?,?);";
													CallableStatement sentenciaStore = arg0.prepareCall(query);
													sentenciaStore.setInt("Par_CedeID", Utileria.convierteEntero(cedesBean.getCedeID()));
													sentenciaStore.setInt("Par_ProductoSAFI", Utileria.convierteEntero(cedesBean.getProductoSAFI()));
													sentenciaStore.setInt("Par_NumAct",tipoTransaccion);

													sentenciaStore.setLong("Par_PolizaID", Utileria.convierteLong((cedesBean.getPolizaID())));
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
														mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .CedesDAO.autoriza");
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
										throw new Exception(Constantes.MSG_ERROR + " .CedesDAO.autoriza");
									}else if(mensajeBean.getNumero()!=0){
										throw new Exception(mensajeBean.getDescripcion());
									}
								} catch (Exception e) {
									loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error al Autorizar la Cede" + e);
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





	public MensajeTransaccionBean reinvertir(final CedesBean cedesBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
					if (cedesBean.getTasaFija()== null){
						cedesBean.setTasaFija(Constantes.STRING_CERO);
					}
					if (cedesBean.getTasaISR()== null){
						cedesBean.setTasaISR(Constantes.STRING_CERO );
					}
					if (cedesBean.getTasaNeta()== null){
						cedesBean.setTasaNeta(Constantes.STRING_CERO );
					}
					if (cedesBean.getInteresGenerado()== null){
						cedesBean.setInteresGenerado(Constantes.STRING_CERO );
					}
					if (cedesBean.getInteresRecibir()== null){
						cedesBean.setInteresRecibir(Constantes.STRING_CERO );
					}
					if (cedesBean.getInteresRetener()== null){
						cedesBean.setInteresRetener(Constantes.STRING_CERO );
					}
					if(cedesBean.getReinversion() == null){
						cedesBean.setReinversion("N");
						cedesBean.setReinvertir("N");
					}else{
						if(cedesBean.getReinversion().equals("N")){
							cedesBean.setReinvertir("N");
						}
					}
			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call PAGOCEDEPRO( ?,?,?,?,?,	?,?,?,?,?,"
												   				   + "?,?,?,?,?,	?,?,?,?,?,"
												   				   + "?,?,?,?,?,	?,?,?,?,?,"
												   				   + "?,?,?,?,?,	?,?,?,?,?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);
									sentenciaStore.setInt("Par_CedeID",Utileria.convierteEntero(cedesBean.getCedeID()));
									sentenciaStore.setString("Par_Fecha",cedesBean.getFechaInicio());
									sentenciaStore.setString("Par_Reinversion", cedesBean.getReinversion());
									sentenciaStore.setString("Par_Reinvertir", cedesBean.getReinvertir());
									sentenciaStore.setString("Par_EsReinversion", "S");
									sentenciaStore.setInt("Par_TipoCedeID", Utileria.convierteEntero(cedesBean.getTipoCedeID()));
									sentenciaStore.setLong("Par_CuentaAhoID",Utileria.convierteLong(cedesBean.getCuentaAhoID()));

									sentenciaStore.setInt("Par_ClienteID",  Utileria.convierteEntero(cedesBean.getClienteID()));
									sentenciaStore.setString("Par_FechaInicio", cedesBean.getFechaInicio());
									sentenciaStore.setString("Par_FechaVencimiento", cedesBean.getFechaVencimiento());
									sentenciaStore.setString("Par_Monto", cedesBean.getMonto());
									sentenciaStore.setInt("Par_Plazo",  Utileria.convierteEntero(cedesBean.getPlazo()));

									sentenciaStore.setDouble("Par_TasaFija", Utileria.convierteDoble(cedesBean.getTasa()));
									sentenciaStore.setDouble("Par_TasaISR", Utileria.convierteDoble(cedesBean.getTasaISR()));
									sentenciaStore.setDouble("Par_TasaNeta", Utileria.convierteDoble(cedesBean.getTasaNeta()));
									sentenciaStore.setInt("Par_CalculoInteres", Utileria.convierteEntero( cedesBean.getCalculoInteres()));
									sentenciaStore.setInt("Par_TasaBaseID",  Utileria.convierteEntero(cedesBean.getTasaBaseID()));

									sentenciaStore.setDouble("Par_SobreTasa",Utileria.convierteDoble(cedesBean.getSobreTasa()));
									sentenciaStore.setDouble("Par_PisoTasa", Utileria.convierteDoble(cedesBean.getPisoTasa()));
									sentenciaStore.setDouble("Par_TechoTasa", Utileria.convierteDoble(cedesBean.getTechoTasa()));
									sentenciaStore.setDouble("Par_InteresGenerado", Utileria.convierteDoble(cedesBean.getInteresGenerado()));
									sentenciaStore.setDouble("Par_InteresRecibir", Utileria.convierteDoble(cedesBean.getInteresRecibir()));

									sentenciaStore.setDouble("Par_InteresRetener", Utileria.convierteDoble(cedesBean.getInteresRetener()));
									sentenciaStore.setDouble("Par_CalGATReal", Utileria.convierteDoble(cedesBean.getValorGatReal()));
									sentenciaStore.setDouble("Par_ValorGat", Utileria.convierteDoble(cedesBean.getValorGat()));
									sentenciaStore.setString("Par_TipoPagoInt", cedesBean.getTipoPagoInt());
									sentenciaStore.setInt("Par_DiasPeriodo", Utileria.convierteEntero(cedesBean.getDiasPeriodo()));
									sentenciaStore.setString("Par_PagoIntCal", cedesBean.getPagoIntCal());

									sentenciaStore.setInt("Par_PlazoOriginal", Utileria.convierteEntero(cedesBean.getPlazoOriginal()));
									sentenciaStore.setString("Par_AltaEnPoliza", "N");
									sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
									sentenciaStore.registerOutParameter("Par_Poliza", Types.INTEGER);

									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
									sentenciaStore.setInt("Par_Empresa",parametrosAuditoriaBean.getEmpresaID());
									sentenciaStore.setInt("Aud_Usuario",parametrosAuditoriaBean.getUsuario());
									sentenciaStore.setDate("Aud_FechaActual",parametrosAuditoriaBean.getFecha());

									sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
									sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
									sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
									sentenciaStore.setLong("Aud_NumTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());


									loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PAGOCEDEPRO "+ sentenciaStore.toString());
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
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .CedesDAO.reinvertir");
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
							throw new Exception(Constantes.MSG_ERROR + " .CedesDAO.reinvertir");
						}else if(mensajeBean.getNumero()!=0){
							throw new Exception(mensajeBean.getDescripcion());
						}
					} catch (Exception e) {
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en reinvertir Cede" + e);
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


	public MensajeTransaccionBean abonar(final CedesBean cedesBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
					if (cedesBean.getTasaFija()== null){
						cedesBean.setTasaFija(Constantes.STRING_CERO);
					}
					if (cedesBean.getTasaISR()== null){
						cedesBean.setTasaISR(Constantes.STRING_CERO );
					}
					if (cedesBean.getTasaNeta()== null){
						cedesBean.setTasaNeta(Constantes.STRING_CERO );
					}
					if (cedesBean.getInteresGenerado()== null){
						cedesBean.setInteresGenerado(Constantes.STRING_CERO );
					}
					if (cedesBean.getInteresRecibir()== null){
						cedesBean.setInteresRecibir(Constantes.STRING_CERO );
					}
					if (cedesBean.getInteresRetener()== null){
						cedesBean.setInteresRetener(Constantes.STRING_CERO );
					}
			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call PAGOCEDEPRO( ?,?,?,?,?,	?,?,?,?,?,"
												   				   + "?,?,?,?,?,	?,?,?,?,?,"
												   				   + "?,?,?,?,?,	?,?,?,?,?,"
												   				   + "?,?,?,?,?,	?,?,?,?,?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);
									sentenciaStore.setInt("Par_CedeID",Utileria.convierteEntero(cedesBean.getCedeID()));
									sentenciaStore.setString("Par_Fecha",cedesBean.getFechaInicio());
									sentenciaStore.setString("Par_Reinversion", "N");
									sentenciaStore.setString("Par_Reinvertir", "N");
									sentenciaStore.setString("Par_EsReinversion", "N");
									sentenciaStore.setInt("Par_TipoCedeID", Utileria.convierteEntero(cedesBean.getTipoCedeID()));
									sentenciaStore.setLong("Par_CuentaAhoID", Utileria.convierteLong(cedesBean.getCuentaAhoID()));

									sentenciaStore.setInt("Par_ClienteID", Utileria.convierteEntero(cedesBean.getClienteID()));
									sentenciaStore.setString("Par_FechaInicio", cedesBean.getFechaInicio());
									sentenciaStore.setString("Par_FechaVencimiento", cedesBean.getFechaVencimiento());
									sentenciaStore.setDouble("Par_Monto", Utileria.convierteDoble(cedesBean.getMonto()));
									sentenciaStore.setInt("Par_Plazo", Utileria.convierteEntero(cedesBean.getPlazo()));

									sentenciaStore.setDouble("Par_TasaFija",  Utileria.convierteDoble(cedesBean.getTasaFija()));
									sentenciaStore.setDouble("Par_TasaISR",  Utileria.convierteDoble(cedesBean.getTasaISR()));
									sentenciaStore.setDouble("Par_TasaNeta",  Utileria.convierteDoble(cedesBean.getTasaNeta()));

									sentenciaStore.setInt("Par_CalculoInteres", Utileria.convierteEntero(cedesBean.getCalculoInteres()));
									sentenciaStore.setInt("Par_TasaBaseID", Utileria.convierteEntero(cedesBean.getTasaBaseID()));

									sentenciaStore.setDouble("Par_SobreTasa", Utileria.convierteDoble(cedesBean.getSobreTasa()));
									sentenciaStore.setDouble("Par_PisoTasa", Utileria.convierteDoble(cedesBean.getPisoTasa()));
									sentenciaStore.setDouble("Par_TechoTasa", Utileria.convierteDoble(cedesBean.getTechoTasa()));
									sentenciaStore.setDouble("Par_InteresGenerado", Utileria.convierteDoble(cedesBean.getInteresGenerado()));
									sentenciaStore.setDouble("Par_InteresRecibir", Utileria.convierteDoble(cedesBean.getInteresRecibir()));

									sentenciaStore.setDouble("Par_InteresRetener", Utileria.convierteDoble(cedesBean.getInteresRetener()));
									sentenciaStore.setDouble("Par_CalGATReal", Utileria.convierteDoble(cedesBean.getValorGatReal()));
									sentenciaStore.setDouble("Par_ValorGat", Utileria.convierteDoble(cedesBean.getValorGat()));
									sentenciaStore.setString("Par_TipoPagoInt", cedesBean.getTipoPagoInt());
									sentenciaStore.setInt("Par_DiasPeriodo", Utileria.convierteEntero(cedesBean.getDiasPeriodo()));
									sentenciaStore.setString("Par_PagoIntCal", cedesBean.getPagoIntCal());

									sentenciaStore.setInt("Par_PlazoOriginal", Utileria.convierteEntero(cedesBean.getPlazoOriginal()));
									sentenciaStore.setString("Par_AltaEnPoliza", "N");
									sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
									sentenciaStore.registerOutParameter("Par_Poliza", Types.INTEGER);

									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
									sentenciaStore.setInt("Par_Empresa",parametrosAuditoriaBean.getEmpresaID());
									sentenciaStore.setInt("Aud_Usuario",parametrosAuditoriaBean.getUsuario());
									sentenciaStore.setDate("Aud_FechaActual",parametrosAuditoriaBean.getFecha());

									sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
									sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
									sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
									sentenciaStore.setLong("Aud_NumTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());



									loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PAGOCEDEPRO "+ sentenciaStore.toString());
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
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .CedesDAO.reinvertir");
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
							throw new Exception(Constantes.MSG_ERROR + " .CedesDAO.reinvertir");
						}else if(mensajeBean.getNumero()!=0){
							throw new Exception(mensajeBean.getDescripcion());
						}
					} catch (Exception e) {
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en reinvertir Cede" + e);
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
	//Consulta principal CEDES
	public CedesBean consultaPrincipal(CedesBean cedesBean, int tipoConsulta){
		CedesBean Cedes = null;
		try{
			String query = "call CEDESCON(" +
				"?,?, ?,?,?,?,?,?,?,?);";

			Object[] parametros = {
					Utileria.convierteEntero(cedesBean.getCedeID()),
					Utileria.convierteEntero(cedesBean.getClienteID()),
				  	tipoConsulta,

					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					"CedesDAO.consulta",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO
				};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CEDESCON(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

					CedesBean cedesBean = new CedesBean();
					cedesBean.setCedeID(String.valueOf(resultSet.getInt("CedeID")));
					cedesBean.setTipoCedeID(resultSet.getString("TipoCedeID"));
					cedesBean.setCuentaAhoID(resultSet.getString("CuentaAhoID"));
					cedesBean.setClienteID(resultSet.getString("ClienteID"));
					cedesBean.setFechaInicio(resultSet.getString("FechaInicio"));
					cedesBean.setFechaVencimiento(resultSet.getString("FechaVencimiento"));
					cedesBean.setMonto(resultSet.getString("Monto"));
					cedesBean.setPlazo(resultSet.getString("Plazo"));
					cedesBean.setTasaFija(resultSet.getString("TasaFija"));
					cedesBean.setTasaISR(resultSet.getString("TasaISR"));
					cedesBean.setTasaNeta(resultSet.getString("TasaNeta"));
					cedesBean.setInteresGenerado(resultSet.getString("InteresGenerado"));
					cedesBean.setInteresRecibir(resultSet.getString("InteresRecibir"));
					cedesBean.setSaldoProvision(resultSet.getString("SaldoProvision"));
					cedesBean.setValorGat(resultSet.getString("ValorGat"));
					cedesBean.setValorGatReal(resultSet.getString("ValorGatReal"));
					cedesBean.setEstatusImpresion(resultSet.getString("EstatusImpresion"));
					cedesBean.setMonedaID(resultSet.getString("MonedaID"));
					cedesBean.setFechaVenAnt(resultSet.getString("FechaVenAnt"));
					cedesBean.setEstatus(resultSet.getString("Estatus"));
					cedesBean.setInteresRetener(resultSet.getString("InteresRetener"));
					cedesBean.setTotalRecibir(resultSet.getString("TotalRecibir"));
					cedesBean.setFechaApertura(resultSet.getString("FechaApertura"));
					cedesBean.setSobreTasa(resultSet.getString("SobreTasa"));
					cedesBean.setPisoTasa(resultSet.getString("PisoTasa"));
					cedesBean.setTechoTasa(resultSet.getString("TechoTasa"));
					cedesBean.setTipoPagoInt(resultSet.getString("TipoPagoInt"));
					cedesBean.setTasaBase(resultSet.getString("TasaBase"));
					cedesBean.setCalculoInteres(resultSet.getString("CalculoInteres"));
					cedesBean.setPlazoOriginal(resultSet.getString("PlazoOriginal"));
					cedesBean.setReinversion(resultSet.getString("Reinversion"));
					cedesBean.setReinvertir(resultSet.getString("Reinvertir"));
					cedesBean.setCedeMadreID(resultSet.getString("CedeMadreID"));
					cedesBean.setCajaRetiro(resultSet.getString("CajaRetiro"));
					cedesBean.setDiasPeriodo(resultSet.getString("DiasPeriodo"));
					cedesBean.setPagoIntCal(resultSet.getString("PagoIntCal"));
					cedesBean.setEstatusISR(resultSet.getString("EstatusISR"));
					return cedesBean;
				}
			});
		cedesBean  = matches.size() > 0 ? (CedesBean) matches.get(0) : null;

		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en consulta de CEDES", e);
		}
		return cedesBean;
	}

	/* Lista principal de CEDES */
	public List listaPrincipal(CedesBean cedesBean, int tipoLista) {
		//Query con el Store Procedure
		String query = "call CEDESLIS(?,?,?,?, ?,?,?,?,?,?,?);";
		Object[] parametros = {	Constantes.ENTERO_CERO,
								cedesBean.getNombreCliente(),
								Constantes.ENTERO_CERO,
								tipoLista,

								parametrosAuditoriaBean.getEmpresaID(),
								parametrosAuditoriaBean.getUsuario(),
								parametrosAuditoriaBean.getFecha(),
								parametrosAuditoriaBean.getDireccionIP(),
								parametrosAuditoriaBean.getNombrePrograma(),
								parametrosAuditoriaBean.getSucursal(),
								Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CEDESLIS(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				CedesBean cedes = new CedesBean();
				cedes.setCedeID(resultSet.getString("CedeID"));
				cedes.setNombreCompleto(resultSet.getString("NombreCompleto"));
				cedes.setMonto(resultSet.getString("Monto"));
				cedes.setFechaVencimiento(resultSet.getString("FechaVencimiento"));
				cedes.setDescripcion(resultSet.getString("Descripcion"));
				cedes.setEstatus(resultSet.getString("Estatus"));
				return cedes;
			}
		});
		return matches;
	}


	public List<CedesBean> resumenCte(CedesBean cedesBean, int tipoLista) {
		List<CedesBean> listaCedesBean = null;
		try{
			//Query con el Store Procedure
			String query = "CALL CEDESLIS(?,?,?,?, ?,?,?,?,?,?,?);";
			Object[] parametros = {
								Utileria.convierteEntero(cedesBean.getClienteID()),
								Constantes.STRING_VACIO,
								Constantes.ENTERO_CERO,
								tipoLista,

								parametrosAuditoriaBean.getEmpresaID(),
								parametrosAuditoriaBean.getUsuario(),
								parametrosAuditoriaBean.getFecha(),
								parametrosAuditoriaBean.getDireccionIP(),
								parametrosAuditoriaBean.getNombrePrograma(),
								parametrosAuditoriaBean.getSucursal(),
								Constantes.ENTERO_CERO};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"CALL CEDESLIS(" + Arrays.toString(parametros) + ")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					CedesBean cedes = new CedesBean();
					cedes.setCedeID(resultSet.getString("CedeID"));
					cedes.setTipoCedeID(resultSet.getString("TipoCedeID"));
					cedes.setFechaInicio(resultSet.getString("FechaInicio"));
					cedes.setFechaVencimiento(resultSet.getString("FechaVencimiento"));
					cedes.setTasaISR(resultSet.getString("TasaISR"));
					cedes.setTasaNeta(resultSet.getString("TasaNeta"));
					cedes.setInteresRecibir(resultSet.getString("InteresRecibir"));
					cedes.setInteresRetener(resultSet.getString("InteresRetener"));
					cedes.setInteresGenerado(resultSet.getString("InteresGenerado"));
					cedes.setMonto(resultSet.getString("Monto"));
					cedes.setTipoPagoInt(resultSet.getString("TipoPagoInt"));
					return cedes;
				}
			});

			listaCedesBean = matches;

		}catch(Exception exception){
			exception.getMessage();
			exception.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+" - "+"error en la lista de Resumen de Cedes ", exception);
			listaCedesBean = null;
		}

		return listaCedesBean;
	}

	/* Lista principal de CEDES */
	public List listaCancelacion(CedesBean cedesBean, int tipoLista) {
		//Query con el Store Procedure
		String query = "call CEDESLIS(?,?,?,?, ?,?,?,?,?,?,?);";
		Object[] parametros = {	Constantes.ENTERO_CERO,
								cedesBean.getNombreCliente(),
								Constantes.ENTERO_CERO,
								tipoLista,

								parametrosAuditoriaBean.getEmpresaID(),
								parametrosAuditoriaBean.getUsuario(),
								parametrosAuditoriaBean.getFecha(),
								parametrosAuditoriaBean.getDireccionIP(),
								parametrosAuditoriaBean.getNombrePrograma(),
								parametrosAuditoriaBean.getSucursal(),
								Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CEDESLIS(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				CedesBean cedes = new CedesBean();
				cedes.setCedeID(resultSet.getString("CedeID"));
				cedes.setNombreCompleto(resultSet.getString("NombreCompleto"));
				cedes.setMonto(resultSet.getString("Monto"));
				cedes.setFechaVencimiento(resultSet.getString("FechaVencimiento"));
				cedes.setDescripcion(resultSet.getString("Descripcion"));
				return cedes;
			}
		});
		return matches;
	}

	/* SIMULADOR DE CALENDARIO DE CEDES */
	public List simulador (final CedesBean cedesBean){
		transaccionDAO.generaNumeroTransaccion();
		List matches =new  ArrayList();
		final List matches2 =new  ArrayList();
		matches = (List) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
				new CallableStatementCreator() {
					public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
							String query = "call CEDESSIMULADORPRO("
									+ "?,?,?,?,?, ?,?,?,?,?,"
									+ "?,?,?,?,?, ?,?,?,?,?);";
							CallableStatement sentenciaStore = arg0.prepareCall(query);
							sentenciaStore.setInt("Par_CedeID",Utileria.convierteEntero(cedesBean.getCedeID()));
							sentenciaStore.setString("Par_FechaInicio",Utileria.convierteFecha(cedesBean.getFechaInicio()));
							sentenciaStore.setString("Par_FechaVencimiento",Utileria.convierteFecha(cedesBean.getFechaVencimiento()));
							sentenciaStore.setDouble("Par_Monto",Utileria.convierteDoble(cedesBean.getMonto()));
							sentenciaStore.setInt("Par_ClienteID",Utileria.convierteEntero(cedesBean.getClienteID()));
							sentenciaStore.setInt("Par_TipoCedeID",Utileria.convierteEntero(cedesBean.getTipoCedeID()));
							sentenciaStore.setDouble("Par_TasaFija",Utileria.convierteDoble(cedesBean.getTasaFija()));
							sentenciaStore.setString("Par_TipoPagoInt",cedesBean.getTipoPagoInt());
							sentenciaStore.setInt("Par_DiasPeriodo",Utileria.convierteEntero(cedesBean.getDiasPeriodo()));
							sentenciaStore.setString("Par_PagoIntCal",cedesBean.getPagoIntCal());
							sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
							sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);

							sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
							sentenciaStore.setInt("Aud_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
							sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
							sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
							sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
							sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
							sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
							sentenciaStore.setLong("Aud_NumTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());

							loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CEDESSIMULADORPRO(  " + sentenciaStore.toString() + ")");
							return sentenciaStore;
						}
					},new CallableStatementCallback() {
						public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,
																											DataAccessException {
							if(callableStatement.execute()){
								ResultSet resultadosStore = callableStatement.getResultSet();

							 while (resultadosStore.next()) {

									CedesBean cedes = new CedesBean();
									cedes.setNumTran(resultadosStore.getString(1));
									cedes.setConsecutivo(resultadosStore.getString(2));
									cedes.setFecha(resultadosStore.getString(3));
									cedes.setFechaPago(resultadosStore.getString(4));
									cedes.setCapital(resultadosStore.getString(5));
									cedes.setInteres(resultadosStore.getString(6));
									cedes.setIsr(resultadosStore.getString(7));
									cedes.setTotal(resultadosStore.getString(8));

									cedes.setTotalCapital(resultadosStore.getString(9));
									cedes.setTotalInteres(resultadosStore.getString(10));
									cedes.setTotalISR(resultadosStore.getString(11));
									cedes.setTotalFinal(resultadosStore.getString(12));
									matches2.add(cedes);
							}
						}
							return matches2;

						}
					});

			return matches;
			}




	//Consulta principal CEDES
		public CedesBean consultaNumeroCedes(CedesBean cedesBean, int tipoConsulta){
			CedesBean Cedes = null;
			try{
				String query = "call CEDESCON(" +
					"?,?, ?,?,?,?,?,?,?,?);";

				Object[] parametros = {
						Utileria.convierteEntero(cedesBean.getCedeID()),
						Utileria.convierteEntero(cedesBean.getClienteID()),
					  	tipoConsulta,

						Constantes.ENTERO_CERO,
						Constantes.ENTERO_CERO,
						Constantes.FECHA_VACIA,
						Constantes.STRING_VACIO,
						"CedesDAO.consulta",
						Constantes.ENTERO_CERO,
						Constantes.ENTERO_CERO
					};
				loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CEDESCON(" + Arrays.toString(parametros) +")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
					public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

						CedesBean cedesBean = new CedesBean();
						cedesBean.setNumCedes(resultSet.getString(1));

						return cedesBean;
					}
				});
			cedesBean  = matches.size() > 0 ? (CedesBean) matches.get(0) : null;

			}catch(Exception e){
				e.printStackTrace();
				loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en consulta de CEDES", e);
			}
			return cedesBean;
		}


		//Consulta principal checkList de CEDES
				public CedesBean consultaCheckList(CedesBean cedesBean, int tipoConsulta){
					CedesBean Cedes = null;
					try{
						String query = "call CEDESCON(" +
							"?,?, ?,?,?,?,?,?,?,?);";

						Object[] parametros = {
								Utileria.convierteEntero(cedesBean.getCedeID()),
								Utileria.convierteEntero(cedesBean.getClienteID()),
							  	tipoConsulta,

								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"CedesDAO.consultaCheckList",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO
							};
						loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CEDESCON(" + Arrays.toString(parametros) +")");
					List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
							public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
								CedesBean cedesBean = new CedesBean();
								cedesBean.setCedeID(String.valueOf(resultSet.getInt("CedeID")));
								cedesBean.setClienteID(resultSet.getString("ClienteID"));
								cedesBean.setNombreCliente(resultSet.getString("NombreCliente"));
								cedesBean.setTipoCedeID(resultSet.getString("TipoCedeID"));
								cedesBean.setDescripcion(resultSet.getString("Descripcion"));
								cedesBean.setEstatus(resultSet.getString("Estatus"));
								cedesBean.setFechaInicio(resultSet.getString("FechaInicio"));
								cedesBean.setFechaVencimiento(resultSet.getString("FechaVencimiento"));
								cedesBean.setMonto(resultSet.getString("Monto"));

								return cedesBean;
							}
						});
					cedesBean  = matches.size() > 0 ? (CedesBean) matches.get(0) : null;

					}catch(Exception e){
						e.printStackTrace();
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en consulta de CEDES", e);
					}
					return cedesBean;
				}


				public CedesBean consultaReinversion(CedesBean cedesBean, int tipoConsulta){
					CedesBean Cedes = null;
					try{
						String query = "call CEDESCON(" +
							"?,?,?,?,?,	?,?,?,?,?);";

						Object[] parametros = {
								Utileria.convierteEntero(cedesBean.getCedeID()),
								Constantes.ENTERO_CERO,
							  	tipoConsulta,

								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"CedesDAO.consulta",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO
							};
						loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CEDESCON(" + Arrays.toString(parametros) +")");
						List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
							public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

								CedesBean cedesBean = new CedesBean();
								cedesBean.setCedeID(String.valueOf(resultSet.getInt("CedeID")));
								cedesBean.setTipoCedeID(resultSet.getString("TipoCedeID"));
								cedesBean.setCuentaAhoID(resultSet.getString("CuentaAhoID"));
								cedesBean.setClienteID(resultSet.getString("ClienteID"));
								cedesBean.setFechaInicio(resultSet.getString("FechaInicio"));

								cedesBean.setFechaVencimiento(resultSet.getString("FechaVencimiento"));
								cedesBean.setMonto(resultSet.getString("Monto"));
								cedesBean.setPlazo(resultSet.getString("Plazo"));
								cedesBean.setTasaFija(resultSet.getString("TasaFija"));
								cedesBean.setTasaISR(resultSet.getString("TasaISR"));

								cedesBean.setTasaNeta(resultSet.getString("TasaNeta"));
								cedesBean.setCalculoInteres(resultSet.getString("CalculoInteres"));
								cedesBean.setTasaBase(resultSet.getString("TasaBase"));
								cedesBean.setSobreTasa(resultSet.getString("SobreTasa"));
								cedesBean.setPisoTasa(resultSet.getString("PisoTasa"));

								cedesBean.setTechoTasa(resultSet.getString("TechoTasa"));
								cedesBean.setInteresGenerado(resultSet.getString("InteresGenerado"));
								cedesBean.setInteresRecibir(resultSet.getString("InteresRecibir"));
								cedesBean.setValorGat(resultSet.getString("ValorGat"));
								cedesBean.setValorGatReal(resultSet.getString("ValorGatReal"));

								cedesBean.setMonedaID(resultSet.getString("MonedaID"));
								cedesBean.setEstatus(resultSet.getString("Estatus"));
								cedesBean.setTipoPagoInt(resultSet.getString("TipoPagoInt"));
								cedesBean.setReinvertir(resultSet.getString("Reinvertir"));
								cedesBean.setDesReinvertir(resultSet.getString("DesReinveritr"));
								cedesBean.setPlazoOriginal(resultSet.getString("PlazoOriginal"));
								cedesBean.setReinversion(resultSet.getString("Reinversion"));
								cedesBean.setCajaRetiro(resultSet.getString("CajaRetiro"));
								cedesBean.setMontosAnclados(resultSet.getString("MontosAnclados"));
								cedesBean.setDiasPeriodo(resultSet.getString("DiasPeriodo"));
								cedesBean.setPagoIntCal(resultSet.getString("PagoIntCal"));

								return cedesBean;
							}
						});
					cedesBean  = matches.size() > 0 ? (CedesBean) matches.get(0) : null;

					}catch(Exception e){
						e.printStackTrace();
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en consulta de CEDES", e);
					}
					return cedesBean;
				}


	public CedesBean consultaAnclaje(CedesBean cedesBean, int tipoConsulta){
		CedesBean Cedes = null;
		try{
			String query = "call CEDESCON(" +
				"?,?, ?,?,?,?,?,?,?,?);";

			Object[] parametros = {
					Utileria.convierteEntero(cedesBean.getCedeID()),
					Utileria.convierteEntero(cedesBean.getClienteID()),
				  	tipoConsulta,

					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					"CedesDAO.consulta",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO
				};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CEDESCON(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					CedesBean cedesBean = new CedesBean();

					cedesBean.setCedeID(resultSet.getString(1));
					cedesBean.setCuentaAhoID(resultSet.getString(2));
					cedesBean.setTipoCedeID(resultSet.getString(3));
					cedesBean.setFechaVencimiento(resultSet.getString(4));
					cedesBean.setMonto(resultSet.getString(5));

					cedesBean.setTasaFija(resultSet.getString(6));
					cedesBean.setEstatus(resultSet.getString(7));
					cedesBean.setClienteID(resultSet.getString(8));
					cedesBean.setMonedaID(resultSet.getString(9));
					cedesBean.setPlazo(resultSet.getString(10));

					cedesBean.setTasaBase(resultSet.getString(11));
					cedesBean.setSobreTasa(resultSet.getString(12));
					cedesBean.setPisoTasa(resultSet.getString(13));
					cedesBean.setTechoTasa(resultSet.getString(14));
					cedesBean.setCalculoInteres(resultSet.getString(15));

					cedesBean.setPlazoOriginal(resultSet.getString(16));
					cedesBean.setInteresGenerado(resultSet.getString(17));
					cedesBean.setInteresRetener(resultSet.getString(18));
					cedesBean.setInteresRecibir(resultSet.getString(19));
					cedesBean.setValorGat(resultSet.getString(20));

					cedesBean.setValorGatReal(resultSet.getString(21));
					cedesBean.setCedeMadreID(resultSet.getString(22));
					cedesBean.setMontosAnclados(resultSet.getString(23));
					cedesBean.setNuevaTasa(resultSet.getString(24));
					cedesBean.setCajaRetiro(resultSet.getString(25));

					return cedesBean;
				}
			});
		cedesBean  = matches.size() > 0 ? (CedesBean) matches.get(0) : null;

		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en consulta de CEDES", e);
		}
		return cedesBean;
	}

	public CedesBean consultaMontosAnclados(CedesBean cedesBean, int tipoConsulta){
		CedesBean Cedes = null;
		try{
			String query = "call CEDESCON(" +
				"?,?,?,?,?,	?,?,?,?,?);";

			Object[] parametros = {
					Utileria.convierteEntero(cedesBean.getCedeID()),
					Constantes.ENTERO_CERO,
				  	tipoConsulta,

					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					"CedesDAO.consulta",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO
				};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CEDESCON(" + Arrays.toString(parametros) +")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

					CedesBean cedesBean = new CedesBean();

					cedesBean.setMontosAnclados(resultSet.getString("MontosAnclados"));
					cedesBean.setInteresesAnclados(resultSet.getString("InteresAnclados"));

					return cedesBean;
				}
			});
		cedesBean  = matches.size() > 0 ? (CedesBean) matches.get(0) : null;

		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en consulta de CEDES", e);
		}
		return cedesBean;
	}


	public CedesBean AjusteAnclaje(CedesBean cedeBean,int tipoConsulta){
		String query = "call CEDESAJUSTECAL(?,?,?,?,?,	?,?,?);";
		Object[] parametros = { Utileria.convierteDoble(cedeBean.getCedeID()),
								cedeBean.getTasa(),
								Utileria.convierteEntero(cedeBean.getTasaBaseID()),
								Utileria.convierteDoble(cedeBean.getSobreTasa()),
								Utileria.convierteDoble(cedeBean.getPisoTasa()),
								Utileria.convierteDoble(cedeBean.getTechoTasa()),
								Utileria.convierteEntero(cedeBean.getCalculoInteres()),
								tipoConsulta

								};



		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CEDESAJUSTECAL(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				CedesBean cedesBean = new CedesBean();

				cedesBean.setInteresGenerado(resultSet.getString("InteresGenerado"));
				cedesBean.setInteresRecibir(resultSet.getString("InteresRecibir"));
				cedesBean.setInteresesAnclados(resultSet.getString("TotalInteres"));

				return cedesBean;
			}
		});


		return matches.size() > 0 ? (CedesBean) matches.get(0) : null;
	}

	/*REPORTE DE CEDES VENCIDAS*/
	public List listaReporteCedesVencidas(CedesBean cedesBean,int tipoLista){
		List ListaCedesVencidas=null;
		try{
			String query="call CEDEVENCIMIENREP(?,?,?,?,?,?,?,  ?,?,?,?,?,?,?);";

			Object[] parametros={
					cedesBean.getFechaInicio(),
					cedesBean.getFechaVencimiento(),
					cedesBean.getCedeID(),
					cedesBean.getSucursalID(),
					cedesBean.getPromotorID(),
					cedesBean.getMonedaID(),
					cedesBean.getEstatus(),

					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					"CedesDAO.listaReporteCedesVencidas",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO

			};

			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CEDEVENCIMIENREP(" + Arrays.toString(parametros) +")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					CedesBean cedesBean = new CedesBean();

					cedesBean.setSucursalID(resultSet.getString("SucursalID"));
					cedesBean.setNombreSucursal(resultSet.getString("NombreSucurs"));
					cedesBean.setNombrePromotor(resultSet.getString("NombrePromotor"));
					cedesBean.setClienteID(resultSet.getString("ClienteID"));
					cedesBean.setNombreCliente(resultSet.getString("NombreCompleto"));
					cedesBean.setTipoCedeID(resultSet.getString("TipoCedeID"));
					cedesBean.setDescripcion(resultSet.getString("DescripCede"));
					cedesBean.setCedeID(resultSet.getString("CedeID"));
					cedesBean.setFechaInicio(resultSet.getString("FechaInicio"));
					cedesBean.setPlazo(resultSet.getString("Plazo"));
					cedesBean.setFechaVencimiento(resultSet.getString("FechaVencimiento"));
					cedesBean.setMonto(resultSet.getString("Monto"));
					cedesBean.setCapital(resultSet.getString("Capital"));
					cedesBean.setTasaFija(resultSet.getString("TasaFija"));
					cedesBean.setTasaISR(resultSet.getString("TasaISR"));
					cedesBean.setInteresGenerado(resultSet.getString("InteresGenerado"));
					cedesBean.setInteresRetener(resultSet.getString("InteresRetener"));
					cedesBean.setInteresRecibir(resultSet.getString("InteresRecibir"));
					cedesBean.setTotalRecibir(resultSet.getString("TotalRecibir"));
					cedesBean.setEstatus(resultSet.getString("Estatus"));



					return cedesBean;
				}
			});
		ListaCedesVencidas=matches;

		}catch(Exception e){
			 e.printStackTrace();
			 loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en consulta de reporte de listaReporteCedesVencidas", e);
		}

	  return ListaCedesVencidas;
	}

	/*REPORTE DE CEDES VIGENTE*/
	public List listaReporteCedesVigentes(CedesBean cedesBean,int tipoLista){
		List ListaCedesVigentes=null;
		try{
			String query="call CEDESREP(?,?,?,?,?,?,?,  ?,?,?,?,?,?);";

			Object[] parametros={
					cedesBean.getTipoCedeID(),
					cedesBean.getPromotorID(),
					cedesBean.getSucursalID(),
					cedesBean.getClienteID(),
					cedesBean.getFechaApertura(),
					Constantes.ENTERO_CERO,

					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					"CedesDAO.listaReporteCedesVencidas",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO

			};

			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CEDESREP(" + Arrays.toString(parametros) +")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					CedesBean cedesBean = new CedesBean();

					cedesBean.setCedeID(resultSet.getString("CedeID"));
					cedesBean.setTipoCedeID(resultSet.getString("TipoCedeID"));
					cedesBean.setDescripcion(resultSet.getString("DescripcionCede"));
					cedesBean.setCuentaAhoID(resultSet.getString("CuentaAhoID"));
					cedesBean.setClienteID(resultSet.getString("ClienteID"));
					cedesBean.setFechaInicio(resultSet.getString("FechaInicio"));
					cedesBean.setFechaVencimiento(resultSet.getString("FechaVencimiento"));
					cedesBean.setMonto(resultSet.getString("Monto"));
					cedesBean.setPlazo(resultSet.getString("Plazo"));
					cedesBean.setTasaFija(resultSet.getString("TasaFija"));
					cedesBean.setTasaISR(resultSet.getString("TasaISR"));
					cedesBean.setEstatus(resultSet.getString("Estatus"));
			        cedesBean.setFechaApertura(resultSet.getString("FechaApertura"));
			        cedesBean.setTasa(resultSet.getString("TasaFV"));
			        cedesBean.setDesTipoCede(resultSet.getString("Descripcion"));
			        cedesBean.setCalculoInteres(resultSet.getString("CalculoInteres"));
			        cedesBean.setFormulaInteres(resultSet.getString("FormulaInteres"));
			        cedesBean.setSobreTasa(resultSet.getString("SobreTasa"));
			        cedesBean.setPisoTasa(resultSet.getString("PisoTasa"));
			        cedesBean.setTechoTasa(resultSet.getString("TechoTasa"));
			        cedesBean.setTasaBase(resultSet.getString("TasaBase"));
			        cedesBean.setDesTasaBase(resultSet.getString("TasaBaseDes"));
			        cedesBean.setNombreCompleto(resultSet.getString("NombreCompleto"));
			        cedesBean.setSucursalID(resultSet.getString("SucursalOrigen"));
			        cedesBean.setNombreSucursal(resultSet.getString("NombreSucurs"));
			        cedesBean.setPromotorID(resultSet.getString("PromotorActual"));
			        cedesBean.setNombrePromotor(resultSet.getString("NombrePromotor"));

					return cedesBean;
				}
			});
		ListaCedesVigentes=matches;

		}catch(Exception e){
			 e.printStackTrace();
			 loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en consulta de reporte de listaReporteCedesVencidas", e);
		}

	  return ListaCedesVigentes;
	}


	/* VENCIMIENTO MASIVO CEDES*/
	public MensajeTransaccionBean vencimientoMasivoCedes(final CedesBean cedesBean) {
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
									String query = "call CEDEVENCMASIVOPRO(" +
										"?,?,?,?,?, ?,?,?,?,?," +
										"?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);
									sentenciaStore.setDate("Par_Fecha",OperacionesFechas.conversionStrDate(cedesBean.getFechaInicio()));
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
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .CedesDAO.vencimientoMasivoCedes");
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
							throw new Exception(Constantes.MSG_ERROR + " .ClientesDAO.altaCliente");
						}else if(mensajeBean.getNumero()!=0){
							throw new Exception(mensajeBean.getDescripcion());
						}
					} catch (Exception e) {
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Alta de Cliente" + e);
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

	/* ACTUALIZA EL VALOR DEL PROCESO DEL VENCIMIENTO MASIVO DE CEDES*/
	public MensajeTransaccionBean actualizaProcesoCedes(final CedesBean cedesBean,final int tipoActualizacion) {
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
								String query = "call PARAMGENERALESACT(?,?,?,?,?,	?,?,?,?,?, ?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);
								sentenciaStore.setInt("Par_NumActualiza",tipoActualizacion);
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
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	/* Validar CEDE*/
	public MensajeTransaccionBean validaCede(final CedesBean cedesBean) {
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
									String query = "call CEDESVAL(?,?,?,	?,?,?,?,?,"
											   				   + "?,?,?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);

									sentenciaStore.setInt("Par_CedeID", Utileria.convierteEntero(cedesBean.getCedeID()));
									sentenciaStore.setInt("Par_ProductoSAFI", Utileria.convierteEntero(cedesBean.getProductoSAFI()));

									sentenciaStore.setString("Par_Salida",salidaPantalla);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

									sentenciaStore.setInt("Aud_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
									sentenciaStore.setInt("Aud_Usuario",parametrosAuditoriaBean.getUsuario());
									sentenciaStore.setDate("Aud_FechaActual",parametrosAuditoriaBean.getFecha());
									sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
									sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
									sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
									sentenciaStore.setLong("Aud_NumTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());

									loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CEDESVAL "+ sentenciaStore.toString());
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
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .CedesDAO.validaCede");
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
							throw new Exception(Constantes.MSG_ERROR + " .CedesDAO.validaCede");
						}else if(mensajeBean.getNumero()!=0){
							throw new Exception(mensajeBean.getDescripcion());
						}
					} catch (Exception e) {
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en la validacion de Cede" + e);
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


	public CedesBean consultaVencimientoAnt(CedesBean cedesBean, int tipoConsulta){
		CedesBean Cedes = null;
		try{
			String query = "call CEDESCON(" +
				"?,?, ?,?,?,?,?,?,?,?);";

			Object[] parametros = {
					Utileria.convierteEntero(cedesBean.getCedeID()),
					Utileria.convierteEntero(cedesBean.getClienteID()),
				  	tipoConsulta,

					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					"CedesDAO.consulta",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO
				};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CEDESCON(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

					CedesBean cedesBean = new CedesBean();
					cedesBean.setCedeID(String.valueOf(resultSet.getInt("CedeID")));
					cedesBean.setTipoCedeID(resultSet.getString("TipoCedeID"));
					cedesBean.setCuentaAhoID(resultSet.getString("CuentaAhoID"));
					cedesBean.setClienteID(resultSet.getString("ClienteID"));
					cedesBean.setFechaInicio(resultSet.getString("FechaInicio"));
					cedesBean.setFechaVencimiento(resultSet.getString("FechaVencimiento"));
					cedesBean.setMonto(resultSet.getString("Monto"));
					cedesBean.setPlazo(resultSet.getString("Plazo"));
					cedesBean.setTasaFija(resultSet.getString("TasaFija"));
					cedesBean.setTasaISR(resultSet.getString("TasaISR"));
					cedesBean.setTasaNeta(resultSet.getString("TasaNeta"));
					cedesBean.setInteresGenerado(resultSet.getString("InteresGenerado"));
					cedesBean.setInteresRecibir(resultSet.getString("InteresRecibir"));
					cedesBean.setSaldoProvision(resultSet.getString("SaldoProvision"));
					cedesBean.setValorGat(resultSet.getString("ValorGat"));
					cedesBean.setValorGatReal(resultSet.getString("ValorGatReal"));
					cedesBean.setEstatusImpresion(resultSet.getString("EstatusImpresion"));
					cedesBean.setMonedaID(resultSet.getString("MonedaID"));
					cedesBean.setFechaVenAnt(resultSet.getString("FechaVenAnt"));
					cedesBean.setEstatus(resultSet.getString("Estatus"));
					cedesBean.setInteresRetener(resultSet.getString("InteresRetener"));
					cedesBean.setTotalRecibir(resultSet.getString("TotalRecibir"));
					cedesBean.setFechaApertura(resultSet.getString("FechaApertura"));
					cedesBean.setSobreTasa(resultSet.getString("SobreTasa"));
					cedesBean.setPisoTasa(resultSet.getString("PisoTasa"));
					cedesBean.setTechoTasa(resultSet.getString("TechoTasa"));
					cedesBean.setTipoPagoInt(resultSet.getString("TipoPagoInt"));
					cedesBean.setTasaBase(resultSet.getString("TasaBase"));
					cedesBean.setCalculoInteres(resultSet.getString("CalculoInteres"));
					cedesBean.setPlazoOriginal(resultSet.getString("PlazoOriginal"));
					cedesBean.setReinversion(resultSet.getString("Reinversion"));
					cedesBean.setReinvertir(resultSet.getString("Reinvertir"));
					cedesBean.setCedeMadreID(resultSet.getString("CedeMadreID"));
					cedesBean.setCajaRetiro(resultSet.getString("CajaRetiro"));
					cedesBean.setInicioPeriodo(resultSet.getString("AmorVig"));
					return cedesBean;
				}
			});
		cedesBean  = matches.size() > 0 ? (CedesBean) matches.get(0) : null;

		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en consulta de CEDES", e);
		}
		return cedesBean;
	}

	/**
	 * Método que trae la lista de resultados de CEDES que no han sido Autorizadas. Reporte de CEDES No Autorizadas.
	 * @param cedesBean : Clase bean con los parámetros de entrada al SP-CEDESPORAUTORIZARREP.
	 * @return List : Lista con el resultado del reporte.
	 * @author avelasco
	 */
	public List reporteCedesPorAurtorizar(CedesBean cedesBean){
		List ListaCedes=null;
		try{
			String query="call CEDESPORAUTORIZARREP(" +
								"?,?,?,?,?,		?,?,?,?,?,		" +
								"?);";

			Object[] parametros={
					Utileria.convierteEntero(cedesBean.getTipoCedeID()),
					Utileria.convierteEntero(cedesBean.getPromotorID()),
					Utileria.convierteEntero(cedesBean.getSucursalID()),
					Utileria.convierteEntero(cedesBean.getClienteID()),
					Constantes.ENTERO_CERO,

					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					"CedesDAO.reporteCedesPorAurtorizar",
					Constantes.ENTERO_CERO,

					Constantes.ENTERO_CERO
			};

			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CEDESPORAUTORIZARREP(" + Arrays.toString(parametros) +");");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					CedesBean cedesBean = new CedesBean();

					cedesBean.setCedeID(resultSet.getString("CedeID"));
					cedesBean.setClienteID(resultSet.getString("ClienteID"));
					cedesBean.setNombreCliente(resultSet.getString("NombreCompleto"));
					cedesBean.setTasaFija(resultSet.getString("Tasa"));
					cedesBean.setTasaISR(resultSet.getString("TasaISR"));

					cedesBean.setTasaNeta(resultSet.getString("TasaNeta"));
					cedesBean.setMonto(resultSet.getString("Monto"));
					cedesBean.setPlazo(resultSet.getString("Plazo"));
					cedesBean.setFechaVencimiento(resultSet.getString("FechaVencimiento"));
					cedesBean.setInteresGenerado(resultSet.getString("InteresGenerado"));

					cedesBean.setInteresRetener(resultSet.getString("InteresRetener"));
					cedesBean.setInteresRecibir(resultSet.getString("InteresRecibir"));
					cedesBean.setEstatus(resultSet.getString("Estatus"));
					return cedesBean;
				}
			});
			ListaCedes=matches;
		} catch(Exception e) {
			 e.printStackTrace();
			 loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en consulta de reporte de Cedes Por Aurtorizar: ", e);
		}

	  return ListaCedes;
	}

	/* Lista de CEDES en Guarda Valores*/
	public List listaGuardaValores(CedesBean cedesBean, int tipoLista) {

		List<CedesBean> listaCedes = null;
		try{
			//Query con el Store Procedure
			String query = "CALL CEDESLIS(?,?,?,?, ?,?,?,?,?,?,?);";
			Object[] parametros = {	Constantes.ENTERO_CERO,
									cedesBean.getNombreCliente(),
									Constantes.ENTERO_CERO,
									tipoLista,

									parametrosAuditoriaBean.getEmpresaID(),
									parametrosAuditoriaBean.getUsuario(),
									parametrosAuditoriaBean.getFecha(),
									parametrosAuditoriaBean.getDireccionIP(),
									parametrosAuditoriaBean.getNombrePrograma(),
									parametrosAuditoriaBean.getSucursal(),
									Constantes.ENTERO_CERO};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"CALL" + Arrays.toString(parametros) + ")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					CedesBean cedes = new CedesBean();
					cedes.setCedeID(Utileria.completaCerosIzquierda(resultSet.getString("CedeID"),7));
					cedes.setNombreCompleto(resultSet.getString("NombreCompleto"));
					cedes.setMonto(resultSet.getString("Monto"));
					cedes.setFechaVencimiento(resultSet.getString("FechaVencimiento"));
					cedes.setDescripcion(resultSet.getString("Descripcion"));
					cedes.setEstatus(resultSet.getString("Estatus"));
					return cedes;
				}
			});

			listaCedes = matches;

		}catch(Exception exception){
			exception.getMessage();
			exception.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+" - "+"error en la lista de Cedes en Guarda Valores", exception);
			listaCedes = null;
		}

		return listaCedes;
	}

	public PolizaDAO getPolizaDAO() {
		return polizaDAO;
	}


	public void setPolizaDAO(PolizaDAO polizaDAO) {
		this.polizaDAO = polizaDAO;
	}


	public PolizaBean getPolizaBean() {
		return polizaBean;
	}

	public void setPolizaBean(PolizaBean polizaBean) {
		this.polizaBean = polizaBean;
	}

	public OperacionesCapitalNetoDAO getOperacionesCapitalNetoDAO() {
		return operacionesCapitalNetoDAO;
	}

	public void setOperacionesCapitalNetoDAO(OperacionesCapitalNetoDAO operacionesCapitalNetoDAO) {
		this.operacionesCapitalNetoDAO = operacionesCapitalNetoDAO;
	}



	}
