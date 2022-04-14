package aportaciones.dao;

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

import aportaciones.bean.AportacionesBean;
import aportaciones.bean.ReciboAportContratoBean;
import contabilidad.bean.PolizaBean;
import contabilidad.dao.PolizaDAO;

public class AportacionesDAO extends BaseDAO{
	ParametrosSesionBean parametrosSesionBean;
	PolizaDAO polizaDAO = null;
	PolizaBean polizaBean;
	private final static String salidaPantalla = "S";

	public AportacionesDAO() {
		super();
	}

	/*Alta de Aportación.*/

	public MensajeTransaccionBean alta(final AportacionesBean aportBean,final int tipoTransaccion) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
					if (aportBean.getTasaFija()== null){
						aportBean.setTasaFija(Constantes.STRING_CERO);
					}
					if (aportBean.getTasaISR()== null){
						aportBean.setTasaISR(Constantes.STRING_CERO );
					}
					if (aportBean.getTasaNeta()== null){
						aportBean.setTasaNeta(Constantes.STRING_CERO );
					}
					if (aportBean.getInteresGenerado()== null){
						aportBean.setInteresGenerado(Constantes.STRING_CERO );
					}
					if (aportBean.getInteresRecibir()== null){
						aportBean.setInteresRecibir(Constantes.STRING_CERO );
					}
					if (aportBean.getInteresRetener()== null){
						aportBean.setInteresRetener(Constantes.STRING_CERO );
					}
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call APORTACIONESALT(?,?,?,?,?,	?,?,?,?,?,"
											+ "?,?,?,?,?,	?,?,?,?,?,"
											+ "?,?,?,?,?,	?,?,?,?,?,"
											+ "?,?,?,?,?,	?,?,?,?,?,"
											+ "?,?,?,?,?,	?,?,?,?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);

									sentenciaStore.setInt("Par_TipoAportacionID",Utileria.convierteEntero(aportBean.getTipoAportacionID()));
									sentenciaStore.setLong("Par_CuentaAhoID",Utileria.convierteLong(aportBean.getCuentaAhoID()));
									sentenciaStore.setInt("Par_ClienteID",Utileria.convierteEntero(aportBean.getClienteID()));
									sentenciaStore.setString("Par_FechaInicio",Utileria.convierteFecha(aportBean.getFechaInicio()));
									sentenciaStore.setString("Par_FechaVencimiento",Utileria.convierteFecha(aportBean.getFechaVencimiento()));

									sentenciaStore.setDouble("Par_Monto",Utileria.convierteDoble(aportBean.getMonto()));
									sentenciaStore.setInt("Par_Plazo",Utileria.convierteEntero(aportBean.getPlazo()));
									sentenciaStore.setDouble("Par_TasaFija",Utileria.convierteDoble(aportBean.getTasaFija()));
									sentenciaStore.setDouble("Par_TasaISR",Utileria.convierteDoble(aportBean.getTasaISR()));
									sentenciaStore.setDouble("Par_TasaNeta",Utileria.convierteDoble(aportBean.getTasaNeta()));

									sentenciaStore.setDouble("Par_InteresGenerado",Utileria.convierteDoble(aportBean.getInteresGenerado()));
									sentenciaStore.setDouble("Par_InteresRecibir",Utileria.convierteDoble(aportBean.getInteresRecibir()));
									sentenciaStore.setDouble("Par_InteresRetener",Utileria.convierteDoble(aportBean.getInteresRetener()));
									sentenciaStore.setDouble("Par_SaldoProvision",Utileria.convierteDoble(aportBean.getSaldoProvision()));
									sentenciaStore.setDouble("Par_ValorGat",Utileria.convierteDoble(aportBean.getValorGat()));

									sentenciaStore.setDouble("Par_ValorGatReal",Utileria.convierteDoble(aportBean.getValorGatReal()));
									sentenciaStore.setInt("Par_MonedaID",Utileria.convierteEntero(aportBean.getMonedaID()));
									sentenciaStore.setString("Par_FechaVenAnt",Utileria.convierteFecha(aportBean.getFechaVenAnt()));
									sentenciaStore.setString("Par_TipoPagoInt", aportBean.getTipoPagoInt());
									sentenciaStore.setInt("Par_DiasPeriodo", Utileria.convierteEntero(aportBean.getDiasPeriodo()));

									sentenciaStore.setString("Par_PagoIntCal", aportBean.getPagoIntCal());
									sentenciaStore.setDouble("Par_CalculoInteres", Utileria.convierteDoble(aportBean.getCalculoInteres()));
									sentenciaStore.setInt("Par_TasaBaseID",Utileria.convierteEntero( aportBean.getTasaBaseID()));
									sentenciaStore.setDouble("Par_SobreTasa",Utileria.convierteDoble(aportBean.getSobreTasa()));
									sentenciaStore.setDouble("Par_PisoTasa", Utileria.convierteDoble(aportBean.getPisoTasa()));

									sentenciaStore.setDouble("Par_TechoTasa", Utileria.convierteDoble(aportBean.getTechoTasa()));
									sentenciaStore.setInt("Par_ProductoSAFI", Utileria.convierteEntero(aportBean.getProductoSAFI()));
									sentenciaStore.setString("Par_Reinversion", aportBean.getReinversion());
									sentenciaStore.setString("Par_Reinvertir", aportBean.getReinvertir());
									sentenciaStore.setInt("Par_TipoAlta",1);

									sentenciaStore.setInt("Par_CajaRetiro",Utileria.convierteEntero(aportBean.getCajaRetiro()));
									sentenciaStore.setInt("Par_PlazoOriginal",Utileria.convierteEntero(aportBean.getPlazoOriginal()));
									sentenciaStore.setInt("Par_DiasPago",Utileria.convierteEntero(aportBean.getDiasPagoInt()));
									sentenciaStore.setString("Par_PagoIntCapitaliza",aportBean.getCapitaliza());
									sentenciaStore.setString("Par_OpcionAportacion",aportBean.getOpcionAport());

									sentenciaStore.setDouble("Par_CantRenovacion",Utileria.convierteDoble(aportBean.getCantidadReno()));
									sentenciaStore.setInt("Par_InvRenovar",Utileria.convierteEntero(aportBean.getInvRenovar()));
									sentenciaStore.setString("Par_Notas",aportBean.getNotas());
									sentenciaStore.setString("Par_AperturaAport",aportBean.getAperturaAport());
									sentenciaStore.registerOutParameter("Par_AportacionID", Types.INTEGER);
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

									loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call APORTACIONESALT "+ sentenciaStore.toString());
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
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .AportacionesDAO.alta");
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
						throw new Exception(Constantes.MSG_ERROR + " .AportacionesDAO.alta");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en alta de Aportaciones: " + e);
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


	/* Modificar Aportación. */
	public MensajeTransaccionBean modificar(final AportacionesBean aportBean,final int tipoTransaccion) {
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
									String query = "call APORTACIONESMOD(" +
											"?,?,?,?,?,       " +
											"?,?,?,?,?,       " +
											"?,?,?,?,?,       " +
											"?,?,?,?,?,       " +
											"?,?,?,?,?,       " +
											"?,?,?,?,?,       " +
											"?,?,?,?,?,       " +
											"?,?,?,?,?,		  " +
											"?,?,?,?,?,		  " +
											"?,?,?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);

									sentenciaStore.setInt("Par_AportacionID",Utileria.convierteEntero(aportBean.getAportacionID()));
									sentenciaStore.setInt("Par_TipoAportacionID",Utileria.convierteEntero(aportBean.getTipoAportacionID()));
									sentenciaStore.setLong("Par_CuentaAhoID",Utileria.convierteLong(aportBean.getCuentaAhoID()));
									sentenciaStore.setInt("Par_ClienteID",Utileria.convierteEntero(aportBean.getClienteID()));
									sentenciaStore.setString("Par_FechaInicio",Utileria.convierteFecha(aportBean.getFechaInicio()));

									sentenciaStore.setString("Par_FechaVencimiento",Utileria.convierteFecha(aportBean.getFechaVencimiento()));
									sentenciaStore.setDouble("Par_Monto",Utileria.convierteDoble(aportBean.getMonto()));
									sentenciaStore.setInt("Par_Plazo",Utileria.convierteEntero(aportBean.getPlazo()));
									sentenciaStore.setDouble("Par_TasaFija",Utileria.convierteDoble(aportBean.getTasaFija()));
									sentenciaStore.setDouble("Par_TasaISR",Utileria.convierteDoble(aportBean.getTasaISR()));

									sentenciaStore.setDouble("Par_TasaNeta",Utileria.convierteDoble(aportBean.getTasaNeta()));
									sentenciaStore.setDouble("Par_InteresGenerado",Utileria.convierteDoble(aportBean.getInteresGenerado()));
									sentenciaStore.setDouble("Par_InteresRecibir",Utileria.convierteDoble(aportBean.getInteresRecibir()));
									sentenciaStore.setDouble("Par_InteresRetener",Utileria.convierteDoble(aportBean.getInteresRetener()));
									sentenciaStore.setDouble("Par_SaldoProvision",Utileria.convierteDoble(aportBean.getSaldoProvision()));

									sentenciaStore.setDouble("Par_ValorGat",Utileria.convierteDoble(aportBean.getValorGat()));
									sentenciaStore.setDouble("Par_ValorGatReal",Utileria.convierteDoble(aportBean.getValorGatReal()));
									sentenciaStore.setInt("Par_MonedaID",Utileria.convierteEntero(aportBean.getMonedaID()));
									sentenciaStore.setString("Par_FechaVenAnt",Utileria.convierteFecha(aportBean.getFechaVenAnt()));
									sentenciaStore.setString("Par_TipoPagoInt" ,aportBean.getTipoPagoInt());

									sentenciaStore.setInt("Par_DiasPeriodo", Utileria.convierteEntero(aportBean.getDiasPeriodo()));
									sentenciaStore.setString("Par_PagoIntCal", aportBean.getPagoIntCal());
									sentenciaStore.setDouble("Par_CalculoInteres", Utileria.convierteDoble(aportBean.getCalculoInteres()));
									sentenciaStore.setInt("Par_TasaBaseID",Utileria.convierteEntero( aportBean.getTasaBaseID()));
									sentenciaStore.setDouble("Par_SobreTasa",Utileria.convierteDoble(aportBean.getSobreTasa()));

									sentenciaStore.setDouble("Par_PisoTasa", Utileria.convierteDoble(aportBean.getPisoTasa()));
									sentenciaStore.setDouble("Par_TechoTasa", Utileria.convierteDoble(aportBean.getTechoTasa()));
									sentenciaStore.setInt("Par_ProductoSAFI", Utileria.convierteEntero(aportBean.getProductoSAFI()));
									sentenciaStore.setInt("Par_PlazoOriginal",Utileria.convierteEntero(aportBean.getPlazoOriginal()));
									sentenciaStore.setString("Par_Reinversion", aportBean.getReinversion());

									sentenciaStore.setString("Par_Reinvertir", aportBean.getReinvertir());
									sentenciaStore.setInt("Par_CajaRetiro",Utileria.convierteEntero(aportBean.getCajaRetiro()));
									sentenciaStore.setInt("Par_DiasPago",Utileria.convierteEntero(aportBean.getDiasPagoInt()));
									sentenciaStore.setString("Par_PagoIntCapitaliza",aportBean.getCapitaliza());
									sentenciaStore.setString("Par_OpcionAportacion",aportBean.getOpcionAport());

									sentenciaStore.setDouble("Par_CantRenovacion",Utileria.convierteDoble(aportBean.getCantidadReno()));
									sentenciaStore.setInt("Par_InvRenovar",Utileria.convierteEntero(aportBean.getInvRenovar()));
									sentenciaStore.setString("Par_Notas",aportBean.getNotas());
									sentenciaStore.setString("Par_AperturaAport",aportBean.getAperturaAport());
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

									loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call APORTACIONESMOD "+ sentenciaStore.toString());
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
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .AportacionesDAO.modificar");
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
						throw new Exception(Constantes.MSG_ERROR + " .AportacionesDAO.modificar");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en modificacion de Aportaciones " + e);
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

	/* Autorizacion de la Aportación */
	public MensajeTransaccionBean autoriza(final AportacionesBean aportBean, final int tipoTransaccion) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		try{
			transaccionDAO.generaNumeroTransaccion();

			// GENERANDO POLIZA CONTABLE
			// -----------------------------------------------------------------
			polizaBean = new PolizaBean();
			aportBean.setPolizaID("0");
			if (tipoTransaccion == 3 || tipoTransaccion == 5) { // 3 AUTORIZACIÓN
				// //5 ANCLAJE
				polizaBean.setConceptoID(aportBean.conceptoMovAPORT);
				polizaBean.setConcepto(aportBean.descripcionMovAPORT);
				int contador = 0;
				/* Llamando al SP de Validacion*/
				mensaje=validaAportacion(aportBean);
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
							aportBean.setPolizaID(numeroPoliza);
							mensajeBean = autorizaAportacion(aportBean, tipoTransaccion);

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
							loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "Error en autorización de la aportación: ", e);
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
						bajaPolizaBean.setDescProceso("AportacionesDAO.autoriza");
						bajaPolizaBean.setPolizaID(aportBean.getPolizaID());
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
			mensaje.setDescripcion("Error al Realizar Autorización de Aportaciones .");
			ex.printStackTrace();
		}
		return mensaje;
	}

	/* Actualizacion de Estatus Impresion Aportación */
	public MensajeTransaccionBean actualizaAportacion(final AportacionesBean aportBean, final int tipoTransaccion) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		// GENERANDO POLIZA CONTABLE
		// -----------------------------------------------------------------
		polizaBean = new PolizaBean();
		aportBean.setPolizaID("0");
		if (tipoTransaccion == 3 || tipoTransaccion == 5) { // 3 AUTORIZACIÓN
			// //5 ANCLAJE
			polizaBean.setConceptoID(aportBean.conceptoMovAPORT);
			polizaBean.setConcepto(aportBean.descripcionMovAPORT);
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

	public MensajeTransaccionBean cancelaAportacion(final AportacionesBean aportBean, final int tipoTransaccion) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();

		// GENERANDO POLIZA CONTABLE
		// -----------------------------------------------------------------
		polizaBean = new PolizaBean();
		aportBean.setPolizaID("0");
		String estado = aportBean.getEstatus();

		if (tipoTransaccion == 10) { // 10 cancelación
			if(estado.compareTo("A") != 0){
				polizaBean.setConceptoID(aportBean.conceptoCancelaAPORT);
				polizaBean.setConcepto(aportBean.descripcionMovCanAPORT);
				int contador = 0;
				while (contador <= PolizaBean.numIntentosGeneraPoliza) {
					contador++;
					mensaje = polizaDAO.generaPolizaIDGenerico(polizaBean, parametrosAuditoriaBean.getNumeroTransaccion());
					if (Utileria.convierteEntero(polizaBean.getPolizaID()) > 0) {
						break;
					}
				}

			}else{
				mensaje = actualizarAportaciones(aportBean, tipoTransaccion);
			}


		}else if (tipoTransaccion == 11) { // 11 VENCIMIENTO ANTICIPADO DE APORTACIONES

			polizaBean.setConceptoID(aportBean.concVenAntAportacion);
			polizaBean.setConcepto(aportBean.descVenAntAportacion);
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

				aportBean.setPolizaID(polizaBean.getPolizaID());
				// actualizar estatus de poliza
				mensaje = actualizarAportaciones(aportBean, tipoTransaccion);

				if(mensaje.getNumero() != 0){
					PolizaBean bajaPolizaBean = new PolizaBean();
					bajaPolizaBean.setTipo(PolizaDAO.Enum_TipoBajaPoliza.bajaPolizaId);
					bajaPolizaBean.setNumTransaccion(String.valueOf(Constantes.ENTERO_CERO));
					bajaPolizaBean.setPolizaID(aportBean.getPolizaID());
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
	public MensajeTransaccionBean actualizarAportaciones(final AportacionesBean aportBean,final int tipoTransaccion) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();

		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call APORTACIONESACT(?,?,?,?, ?,?,?, ?,?,?,?,?,?,?);";

									CallableStatement sentenciaStore = arg0.prepareCall(query);
									sentenciaStore.setInt("Par_AportacionID", Utileria.convierteEntero(aportBean.getAportacionID()));
									sentenciaStore.setInt("Par_ProductoSAFI", Utileria.convierteEntero(aportBean.getProductoSAFI()));
									sentenciaStore.setInt("Par_NumAct",tipoTransaccion);

									sentenciaStore.setLong("Par_PolizaID", Utileria.convierteLong((aportBean.getPolizaID())));
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
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .AportacionesDAO.cancelar");
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
						throw new Exception(Constantes.MSG_ERROR + " .AportacionesDAO.modificar");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en actualizacion de estatus de Aportaciones " + e);
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

	public MensajeTransaccionBean autorizaAportacion(final AportacionesBean aportBean, final int tipoTransaccion) {
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
											String query = "call APORTACIONESACT(?,?,?,?, ?,?,?, ?,?,?,?,?,?,?);";
											CallableStatement sentenciaStore = arg0.prepareCall(query);
											sentenciaStore.setInt("Par_AportacionID", Utileria.convierteEntero(aportBean.getAportacionID()));
											sentenciaStore.setInt("Par_ProductoSAFI", Utileria.convierteEntero(aportBean.getProductoSAFI()));
											sentenciaStore.setInt("Par_NumAct",tipoTransaccion);

											sentenciaStore.setLong("Par_PolizaID", Utileria.convierteLong((aportBean.getPolizaID())));
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
												mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .AportacionesDAO.autoriza");
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
								throw new Exception(Constantes.MSG_ERROR + " .AportacionesDAO.autoriza");
							}else if(mensajeBean.getNumero()!=0){
								throw new Exception(mensajeBean.getDescripcion());
							}
						} catch (Exception e) {
							loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error al Autorizar la Aportacion" + e);
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





	public MensajeTransaccionBean reinvertir(final AportacionesBean aportBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
					if (aportBean.getTasaFija()== null){
						aportBean.setTasaFija(Constantes.STRING_CERO);
					}
					if (aportBean.getTasaISR()== null){
						aportBean.setTasaISR(Constantes.STRING_CERO );
					}
					if (aportBean.getTasaNeta()== null){
						aportBean.setTasaNeta(Constantes.STRING_CERO );
					}
					if (aportBean.getInteresGenerado()== null){
						aportBean.setInteresGenerado(Constantes.STRING_CERO );
					}
					if (aportBean.getInteresRecibir()== null){
						aportBean.setInteresRecibir(Constantes.STRING_CERO );
					}
					if (aportBean.getInteresRetener()== null){
						aportBean.setInteresRetener(Constantes.STRING_CERO );
					}
					if(aportBean.getReinversion() == null){
						aportBean.setReinversion("N");
						aportBean.setReinvertir("N");
					}else{
						if(aportBean.getReinversion().equals("N")){
							aportBean.setReinvertir("N");
						}
					}
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call APORTPAGOPRO( ?,?,?,?,?,	?,?,?,?,?,"
											+ "?,?,?,?,?,	?,?,?,?,?,"
											+ "?,?,?,?,?,	?,?,?,?,?,"
											+ "?,?,?,?,?,	?,?,?,?,?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);
									sentenciaStore.setInt("Par_AportacionID",Utileria.convierteEntero(aportBean.getAportacionID()));
									sentenciaStore.setString("Par_Fecha",aportBean.getFechaInicio());
									sentenciaStore.setString("Par_Reinversion", aportBean.getReinversion());
									sentenciaStore.setString("Par_Reinvertir", aportBean.getReinvertir());
									sentenciaStore.setString("Par_EsReinversion", "S");
									sentenciaStore.setInt("Par_TipoAportacionID", Utileria.convierteEntero(aportBean.getTipoAportacionID()));
									sentenciaStore.setLong("Par_CuentaAhoID",Utileria.convierteLong(aportBean.getCuentaAhoID()));

									sentenciaStore.setInt("Par_ClienteID",  Utileria.convierteEntero(aportBean.getClienteID()));
									sentenciaStore.setString("Par_FechaInicio", aportBean.getFechaInicio());
									sentenciaStore.setString("Par_FechaVencimiento", aportBean.getFechaVencimiento());
									sentenciaStore.setString("Par_Monto", aportBean.getMonto());
									sentenciaStore.setInt("Par_Plazo",  Utileria.convierteEntero(aportBean.getPlazo()));

									sentenciaStore.setDouble("Par_TasaFija", Utileria.convierteDoble(aportBean.getTasa()));
									sentenciaStore.setDouble("Par_TasaISR", Utileria.convierteDoble(aportBean.getTasaISR()));
									sentenciaStore.setDouble("Par_TasaNeta", Utileria.convierteDoble(aportBean.getTasaNeta()));
									sentenciaStore.setInt("Par_CalculoInteres", Utileria.convierteEntero( aportBean.getCalculoInteres()));
									sentenciaStore.setInt("Par_TasaBaseID",  Utileria.convierteEntero(aportBean.getTasaBaseID()));

									sentenciaStore.setDouble("Par_SobreTasa",Utileria.convierteDoble(aportBean.getSobreTasa()));
									sentenciaStore.setDouble("Par_PisoTasa", Utileria.convierteDoble(aportBean.getPisoTasa()));
									sentenciaStore.setDouble("Par_TechoTasa", Utileria.convierteDoble(aportBean.getTechoTasa()));
									sentenciaStore.setDouble("Par_InteresGenerado", Utileria.convierteDoble(aportBean.getInteresGenerado()));
									sentenciaStore.setDouble("Par_InteresRecibir", Utileria.convierteDoble(aportBean.getInteresRecibir()));

									sentenciaStore.setDouble("Par_InteresRetener", Utileria.convierteDoble(aportBean.getInteresRetener()));
									sentenciaStore.setDouble("Par_CalGATReal", Utileria.convierteDoble(aportBean.getValorGatReal()));
									sentenciaStore.setDouble("Par_ValorGat", Utileria.convierteDoble(aportBean.getValorGat()));
									sentenciaStore.setString("Par_TipoPagoInt", aportBean.getTipoPagoInt());
									sentenciaStore.setInt("Par_DiasPeriodo", Utileria.convierteEntero(aportBean.getDiasPeriodo()));
									sentenciaStore.setString("Par_PagoIntCal", aportBean.getPagoIntCal());

									sentenciaStore.setInt("Par_PlazoOriginal", Utileria.convierteEntero(aportBean.getPlazoOriginal()));
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


									loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call APORTPAGOPRO "+ sentenciaStore.toString());
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
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .AportacionesDAO.reinvertir");
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
						throw new Exception(Constantes.MSG_ERROR + " .AportacionesDAO.reinvertir");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en reinvertir Aportacion" + e);
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


	public MensajeTransaccionBean abonar(final AportacionesBean aportBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
					if (aportBean.getTasaFija()== null){
						aportBean.setTasaFija(Constantes.STRING_CERO);
					}
					if (aportBean.getTasaISR()== null){
						aportBean.setTasaISR(Constantes.STRING_CERO );
					}
					if (aportBean.getTasaNeta()== null){
						aportBean.setTasaNeta(Constantes.STRING_CERO );
					}
					if (aportBean.getInteresGenerado()== null){
						aportBean.setInteresGenerado(Constantes.STRING_CERO );
					}
					if (aportBean.getInteresRecibir()== null){
						aportBean.setInteresRecibir(Constantes.STRING_CERO );
					}
					if (aportBean.getInteresRetener()== null){
						aportBean.setInteresRetener(Constantes.STRING_CERO );
					}
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call APORTPAGOPRO( ?,?,?,?,?,	?,?,?,?,?,"
											+ "?,?,?,?,?,	?,?,?,?,?,"
											+ "?,?,?,?,?,	?,?,?,?,?,"
											+ "?,?,?,?,?,	?,?,?,?,?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);
									sentenciaStore.setInt("Par_AportacionID",Utileria.convierteEntero(aportBean.getAportacionID()));
									sentenciaStore.setString("Par_Fecha",aportBean.getFechaInicio());
									sentenciaStore.setString("Par_Reinversion", "N");
									sentenciaStore.setString("Par_Reinvertir", "N");
									sentenciaStore.setString("Par_EsReinversion", "N");
									sentenciaStore.setInt("Par_TipoAportacionID", Utileria.convierteEntero(aportBean.getTipoAportacionID()));
									sentenciaStore.setLong("Par_CuentaAhoID", Utileria.convierteLong(aportBean.getCuentaAhoID()));

									sentenciaStore.setInt("Par_ClienteID", Utileria.convierteEntero(aportBean.getClienteID()));
									sentenciaStore.setString("Par_FechaInicio", aportBean.getFechaInicio());
									sentenciaStore.setString("Par_FechaVencimiento", aportBean.getFechaVencimiento());
									sentenciaStore.setDouble("Par_Monto", Utileria.convierteDoble(aportBean.getMonto()));
									sentenciaStore.setInt("Par_Plazo", Utileria.convierteEntero(aportBean.getPlazo()));

									sentenciaStore.setDouble("Par_TasaFija",  Utileria.convierteDoble(aportBean.getTasaFija()));
									sentenciaStore.setDouble("Par_TasaISR",  Utileria.convierteDoble(aportBean.getTasaISR()));
									sentenciaStore.setDouble("Par_TasaNeta",  Utileria.convierteDoble(aportBean.getTasaNeta()));

									sentenciaStore.setInt("Par_CalculoInteres", Utileria.convierteEntero(aportBean.getCalculoInteres()));
									sentenciaStore.setInt("Par_TasaBaseID", Utileria.convierteEntero(aportBean.getTasaBaseID()));

									sentenciaStore.setDouble("Par_SobreTasa", Utileria.convierteDoble(aportBean.getSobreTasa()));
									sentenciaStore.setDouble("Par_PisoTasa", Utileria.convierteDoble(aportBean.getPisoTasa()));
									sentenciaStore.setDouble("Par_TechoTasa", Utileria.convierteDoble(aportBean.getTechoTasa()));
									sentenciaStore.setDouble("Par_InteresGenerado", Utileria.convierteDoble(aportBean.getInteresGenerado()));
									sentenciaStore.setDouble("Par_InteresRecibir", Utileria.convierteDoble(aportBean.getInteresRecibir()));

									sentenciaStore.setDouble("Par_InteresRetener", Utileria.convierteDoble(aportBean.getInteresRetener()));
									sentenciaStore.setDouble("Par_CalGATReal", Utileria.convierteDoble(aportBean.getValorGatReal()));
									sentenciaStore.setDouble("Par_ValorGat", Utileria.convierteDoble(aportBean.getValorGat()));
									sentenciaStore.setString("Par_TipoPagoInt", aportBean.getTipoPagoInt());
									sentenciaStore.setInt("Par_DiasPeriodo", Utileria.convierteEntero(aportBean.getDiasPeriodo()));
									sentenciaStore.setString("Par_PagoIntCal", aportBean.getPagoIntCal());

									sentenciaStore.setInt("Par_PlazoOriginal", Utileria.convierteEntero(aportBean.getPlazoOriginal()));
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



									loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call APORTPAGOPRO "+ sentenciaStore.toString());
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
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .AportacionesDAO.reinvertir");
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
						throw new Exception(Constantes.MSG_ERROR + " .AportacionesDAO.reinvertir");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en reinvertir Aportacion" + e);
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
	//Consulta principal Aportaciones
	public AportacionesBean consultaPrincipal(AportacionesBean aportBean, int tipoConsulta){
		AportacionesBean Aportaciones = null;
		try{
			String query = "call APORTACIONESCON(" +
					"?,?,?,?," +
					"?,?,?,?,?,?,?);";

			Object[] parametros = {
					Utileria.convierteEntero(aportBean.getAportacionID()),
					Constantes.ENTERO_CERO,
					Utileria.convierteEntero(aportBean.getClienteID()),
					tipoConsulta,

					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					"AportacionesDAO.consulta",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call APORTACIONESCON(" + Arrays.toString(parametros) +")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

					AportacionesBean aportBean = new AportacionesBean();
					aportBean.setAportacionID(String.valueOf(resultSet.getInt("AportacionID")));
					aportBean.setTipoAportacionID(resultSet.getString("TipoAportacionID"));
					aportBean.setCuentaAhoID(resultSet.getString("CuentaAhoID"));
					aportBean.setClienteID(resultSet.getString("ClienteID"));
					aportBean.setFechaInicio(resultSet.getString("FechaInicio"));
					aportBean.setFechaVencimiento(resultSet.getString("FechaVencimiento"));
					aportBean.setMonto(resultSet.getString("Monto"));
					aportBean.setPlazo(resultSet.getString("Plazo"));
					aportBean.setTasaFija(resultSet.getString("TasaFija"));
					aportBean.setTasaISR(resultSet.getString("TasaISR"));
					aportBean.setTasaNeta(resultSet.getString("TasaNeta"));
					aportBean.setInteresGenerado(resultSet.getString("InteresGenerado"));
					aportBean.setInteresRecibir(resultSet.getString("InteresRecibir"));
					aportBean.setSaldoProvision(resultSet.getString("SaldoProvision"));
					aportBean.setValorGat(resultSet.getString("ValorGat"));
					aportBean.setValorGatReal(resultSet.getString("ValorGatReal"));
					aportBean.setEstatusImpresion(resultSet.getString("EstatusImpresion"));
					aportBean.setMonedaID(resultSet.getString("MonedaID"));
					aportBean.setFechaVenAnt(resultSet.getString("FechaVenAnt"));
					aportBean.setEstatus(resultSet.getString("Estatus"));
					aportBean.setInteresRetener(resultSet.getString("InteresRetener"));
					aportBean.setTotalRecibir(resultSet.getString("TotalRecibir"));
					aportBean.setFechaApertura(resultSet.getString("FechaApertura"));
					aportBean.setSobreTasa(resultSet.getString("SobreTasa"));
					aportBean.setPisoTasa(resultSet.getString("PisoTasa"));
					aportBean.setTechoTasa(resultSet.getString("TechoTasa"));
					aportBean.setTipoPagoInt(resultSet.getString("TipoPagoInt"));
					aportBean.setTasaBase(resultSet.getString("TasaBase"));
					aportBean.setCalculoInteres(resultSet.getString("CalculoInteres"));
					aportBean.setPlazoOriginal(resultSet.getString("PlazoOriginal"));
					aportBean.setReinversion(resultSet.getString("Reinversion"));
					aportBean.setReinvertir(resultSet.getString("Reinvertir"));
					aportBean.setAportacionMadreID(resultSet.getString("AportMadreID"));
					aportBean.setCajaRetiro(resultSet.getString("CajaRetiro"));
					aportBean.setDiasPeriodo(resultSet.getString("DiasPeriodo"));
					aportBean.setPagoIntCal(resultSet.getString("PagoIntCal"));
					aportBean.setEstatusISR(resultSet.getString("EstatusISR"));
					aportBean.setComentarios(resultSet.getString("Comentarios"));
					aportBean.setMaxPuntos(resultSet.getString("MaxPuntos"));
					aportBean.setMinPuntos(resultSet.getString("MinPuntos"));
					aportBean.setPerfilAutoriza(resultSet.getString("perfilAutoriza"));
					aportBean.setMontoGlobal(resultSet.getString("MontoGlobal"));
					aportBean.setTasaMontoGlobal(resultSet.getString("TasaMontoGlobal"));
					aportBean.setIncluyeGpoFam(resultSet.getString("IncluyeGpoFam"));
					aportBean.setDiasPagoInt(resultSet.getString("DiasPago"));
					aportBean.setCapitaliza(resultSet.getString("PagoIntCapitaliza"));
					aportBean.setOpcionAport(resultSet.getString("OpcionAport"));
					aportBean.setCantidadReno(resultSet.getString("CantidadReno"));
					aportBean.setInvRenovar(resultSet.getString("InvRenovar"));
					aportBean.setNotas(resultSet.getString("Notas"));
					aportBean.setAperturaAport(resultSet.getString("AperturaAport"));
					aportBean.setConsolidarSaldos(resultSet.getString("ConsolidarSaldos"));
					aportBean.setAportConsolID(resultSet.getString("AportConsID"));
					aportBean.setTotalFinal(resultSet.getString("TotalFinal"));
					return aportBean;
				}
			});
			aportBean  = matches.size() > 0 ? (AportacionesBean) matches.get(0) : null;

		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en consulta de Aportaciones", e);
		}
		return aportBean;
	}

	/* Lista principal de Aportaciones */
	public List listaPrincipal(AportacionesBean aportBean, int tipoLista) {
		//Query con el Store Procedure
		String query = "call APORTACIONESLIS(?,?,?,?, ?,?,?,?,?,?,?);";
		Object[] parametros = {
				aportBean.getClienteID(),
				aportBean.getNombreCliente(),
				Constantes.ENTERO_CERO,
				tipoLista,

				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				parametrosAuditoriaBean.getNombrePrograma(),
				parametrosAuditoriaBean.getSucursal(),
				Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call APORTACIONESLIS(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				AportacionesBean aportaciones = new AportacionesBean();
				aportaciones.setAportacionID(resultSet.getString("AportacionID"));
				aportaciones.setNombreCompleto(resultSet.getString("NombreCompleto"));
				aportaciones.setMonto(resultSet.getString("Monto"));
				aportaciones.setFechaVencimiento(resultSet.getString("FechaVencimiento"));
				aportaciones.setDescripcion(resultSet.getString("Descripcion"));
				aportaciones.setEstatus(resultSet.getString("Estatus"));
				return aportaciones;
			}
		});
		return matches;
	}


	public List<AportacionesBean> resumenCte(AportacionesBean aportBean, int tipoLista) {
		List<AportacionesBean> listaAportacionesBean = null;
		try{
			//Query con el Store Procedure
			String query = "call APORTACIONESLIS(?,?,?,?, ?,?,?,?,?,?,?);";
			Object[] parametros = {
				Utileria.convierteEntero(aportBean.getClienteID()),
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
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call APORTACIONESLIS(" + Arrays.toString(parametros) + ")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					AportacionesBean aportaciones = new AportacionesBean();
					aportaciones.setAportacionID(resultSet.getString("AportacionID"));
					aportaciones.setTipoAportacionID(resultSet.getString("TipoAportacionID"));
					aportaciones.setFechaInicio(resultSet.getString("FechaInicio"));
					aportaciones.setFechaVencimiento(resultSet.getString("FechaVencimiento"));
					aportaciones.setTasaISR(resultSet.getString("TasaISR"));
					aportaciones.setTasaNeta(resultSet.getString("TasaNeta"));
					aportaciones.setInteresRecibir(resultSet.getString("InteresRecibir"));
					aportaciones.setInteresRetener(resultSet.getString("InteresRetener"));
					aportaciones.setInteresGenerado(resultSet.getString("InteresGenerado"));
					aportaciones.setMonto(resultSet.getString("Monto"));
					aportaciones.setTipoPagoInt(resultSet.getString("TipoPagoInt"));
					return aportaciones;
				}
			});

			listaAportacionesBean = matches;

		}catch(Exception exception){
			exception.getMessage();
			exception.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+" - "+"error en la lista de Resumen de Aportaciones ", exception);
			listaAportacionesBean = null;
		}

		return listaAportacionesBean;
	}

	/* Lista principal de Aportaciones */
	public List listaCancelacion(AportacionesBean aportBean, int tipoLista) {
		//Query con el Store Procedure
		String query = "call APORTACIONESLIS(?,?,?,?, ?,?,?,?,?,?,?);";
		Object[] parametros = {	Constantes.ENTERO_CERO,
				aportBean.getNombreCliente(),
				Constantes.ENTERO_CERO,
				tipoLista,

				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				parametrosAuditoriaBean.getNombrePrograma(),
				parametrosAuditoriaBean.getSucursal(),
				Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call APORTACIONESLIS(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				AportacionesBean aportaciones = new AportacionesBean();
				aportaciones.setAportacionID(resultSet.getString("AportacionID"));
				aportaciones.setNombreCompleto(resultSet.getString("NombreCompleto"));
				aportaciones.setMonto(resultSet.getString("Monto"));
				aportaciones.setFechaVencimiento(resultSet.getString("FechaVencimiento"));
				aportaciones.setDescripcion(resultSet.getString("Descripcion"));
				return aportaciones;
			}
		});
		return matches;
	}

	/* SIMULADOR DE CALENDARIO DE APORTACIONES */
	public List simulador (final AportacionesBean aportBean){
		transaccionDAO.generaNumeroTransaccion();
		List matches =new  ArrayList();
		final List matches2 =new  ArrayList();
		matches = (List) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
				new CallableStatementCreator() {
					public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
						String query = "call APORTSIMULADORPRO("
								+ "?,?,?,?,?, ?,?,?,?,?,"
								+ "?,?,?,?,?, ?,?,?,?,?,"
								+ "?,?,?);";
						CallableStatement sentenciaStore = arg0.prepareCall(query);
						sentenciaStore.setInt("Par_AportacionID",Utileria.convierteEntero(aportBean.getAportacionID()));
						sentenciaStore.setString("Par_FechaInicio",Utileria.convierteFecha(aportBean.getFechaInicio()));
						sentenciaStore.setString("Par_FechaVencimiento",Utileria.convierteFecha(aportBean.getFechaVencimiento()));
						sentenciaStore.setDouble("Par_Monto",Utileria.convierteDoble(aportBean.getMonto()));
						sentenciaStore.setInt("Par_ClienteID",Utileria.convierteEntero(aportBean.getClienteID()));

						sentenciaStore.setInt("Par_TipoAportacionID",Utileria.convierteEntero(aportBean.getTipoAportacionID()));
						sentenciaStore.setDouble("Par_TasaFija",Utileria.convierteDoble(aportBean.getTasaFija()));
						sentenciaStore.setString("Par_TipoPagoInt",aportBean.getTipoPagoInt());
						sentenciaStore.setInt("Par_DiasPeriodo",Utileria.convierteEntero(aportBean.getDiasPeriodo()));
						sentenciaStore.setString("Par_PagoIntCal",aportBean.getPagoIntCal());

						sentenciaStore.setInt("Par_DiaPago",Utileria.convierteEntero(aportBean.getDiasPagoInt()));
						sentenciaStore.setInt("Par_PlazoOriginal",Utileria.convierteEntero(aportBean.getPlazoOriginal()));
						sentenciaStore.setString("Par_IntCapitaliza",aportBean.getCapitaliza());
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

						loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call APORTSIMULADORPRO(  " + sentenciaStore.toString() + ")");
						return sentenciaStore;
					}
				},new CallableStatementCallback() {
					public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,
					DataAccessException {
						if(callableStatement.execute()){
							ResultSet resultadosStore = callableStatement.getResultSet();

							while (resultadosStore.next()) {

								AportacionesBean aportaciones = new AportacionesBean();
								aportaciones.setNumTran(resultadosStore.getString("NumTransaccion"));
								aportaciones.setConsecutivo(resultadosStore.getString("Consecutivo"));
								aportaciones.setFecha(resultadosStore.getString("Fecha"));
								aportaciones.setFechaPago(resultadosStore.getString("FechaPago"));
								aportaciones.setCapital(resultadosStore.getString("Capital"));
								aportaciones.setInteres(resultadosStore.getString("Interes"));
								aportaciones.setIsr(resultadosStore.getString("ISR"));
								aportaciones.setTotal(resultadosStore.getString("Total"));

								aportaciones.setTotalCapital(resultadosStore.getString("VarTotalCapital"));
								aportaciones.setTotalInteres(resultadosStore.getString("VarTotalInteres"));
								aportaciones.setTotalISR(resultadosStore.getString("VarTotalISR"));
								aportaciones.setTotalFinal(resultadosStore.getString("VarTotalFinal"));
								aportaciones.setSaldoCapital(resultadosStore.getString("SaldoCap"));
								matches2.add(aportaciones);
							}
						}
						return matches2;

					}
				});

		return matches;
	}




	//Consulta principal Aportaciones
	public AportacionesBean consultaNumeroAportaciones(AportacionesBean aportBean, int tipoConsulta){
		AportacionesBean Aportaciones = null;
		try{
			String query = "call APORTACIONESCON(" +
					"?,?,?,?," +
					"?,?,?,?,?,?,?);";

			Object[] parametros = {
					Utileria.convierteEntero(aportBean.getAportacionID()),
					Constantes.ENTERO_CERO,
					Utileria.convierteEntero(aportBean.getClienteID()),
					tipoConsulta,

					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					"AportacionesDAO.consulta",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call APORTACIONESCON(" + Arrays.toString(parametros) +")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

					AportacionesBean aportBean = new AportacionesBean();
					aportBean.setNumAportaciones(resultSet.getString(1));

					return aportBean;
				}
			});
			aportBean  = matches.size() > 0 ? (AportacionesBean) matches.get(0) : null;

		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en consulta de Aportaciones", e);
		}
		return aportBean;
	}


	//Consulta principal checkList de Aportaciones
	public AportacionesBean consultaCheckList(AportacionesBean aportBean, int tipoConsulta){
		AportacionesBean Aportaciones = null;
		try{
			String query = "call APORTACIONESCON(" +
					"?,?,?,?," +
					"?,?,?,?,?,?,?);";

			Object[] parametros = {
					Utileria.convierteEntero(aportBean.getAportacionID()),
					Constantes.ENTERO_CERO,
					Utileria.convierteEntero(aportBean.getClienteID()),
					tipoConsulta,

					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					"AportacionesDAO.consultaCheckList",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call APORTACIONESCON(" + Arrays.toString(parametros) +")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					AportacionesBean aportBean = new AportacionesBean();
					aportBean.setAportacionID(String.valueOf(resultSet.getInt("AportacionID")));
					aportBean.setClienteID(resultSet.getString("ClienteID"));
					aportBean.setNombreCliente(resultSet.getString("NombreCliente"));
					aportBean.setTipoAportacionID(resultSet.getString("TipoAportacionID"));
					aportBean.setDescripcion(resultSet.getString("Descripcion"));
					aportBean.setEstatus(resultSet.getString("Estatus"));
					aportBean.setFechaInicio(resultSet.getString("FechaInicio"));
					aportBean.setFechaVencimiento(resultSet.getString("FechaVencimiento"));
					aportBean.setMonto(resultSet.getString("Monto"));

					return aportBean;
				}
			});
			aportBean  = matches.size() > 0 ? (AportacionesBean) matches.get(0) : null;

		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en consulta de Aportaciones", e);
		}
		return aportBean;
	}


	public AportacionesBean consultaReinversion(AportacionesBean aportBean, int tipoConsulta){
		AportacionesBean Aportaciones = null;
		try{
			String query = "call APORTACIONESCON(" +
					"?,?,?,?," +
					"?,?,?,?,?,?,?);";

			Object[] parametros = {
					Utileria.convierteEntero(aportBean.getAportacionID()),
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					tipoConsulta,

					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					"AportacionesDAO.consulta",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call APORTACIONESCON(" + Arrays.toString(parametros) +")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

					AportacionesBean aportBean = new AportacionesBean();
					aportBean.setAportacionID(String.valueOf(resultSet.getInt("AportacionID")));
					aportBean.setTipoAportacionID(resultSet.getString("TipoAportacionID"));
					aportBean.setCuentaAhoID(resultSet.getString("CuentaAhoID"));
					aportBean.setClienteID(resultSet.getString("ClienteID"));
					aportBean.setFechaInicio(resultSet.getString("FechaInicio"));

					aportBean.setFechaVencimiento(resultSet.getString("FechaVencimiento"));
					aportBean.setMonto(resultSet.getString("Monto"));
					aportBean.setPlazo(resultSet.getString("Plazo"));
					aportBean.setTasaFija(resultSet.getString("TasaFija"));
					aportBean.setTasaISR(resultSet.getString("TasaISR"));

					aportBean.setTasaNeta(resultSet.getString("TasaNeta"));
					aportBean.setCalculoInteres(resultSet.getString("CalculoInteres"));
					aportBean.setTasaBase(resultSet.getString("TasaBase"));
					aportBean.setSobreTasa(resultSet.getString("SobreTasa"));
					aportBean.setPisoTasa(resultSet.getString("PisoTasa"));

					aportBean.setTechoTasa(resultSet.getString("TechoTasa"));
					aportBean.setInteresGenerado(resultSet.getString("InteresGenerado"));
					aportBean.setInteresRecibir(resultSet.getString("InteresRecibir"));
					aportBean.setValorGat(resultSet.getString("ValorGat"));
					aportBean.setValorGatReal(resultSet.getString("ValorGatReal"));

					aportBean.setMonedaID(resultSet.getString("MonedaID"));
					aportBean.setEstatus(resultSet.getString("Estatus"));
					aportBean.setTipoPagoInt(resultSet.getString("TipoPagoInt"));
					aportBean.setReinvertir(resultSet.getString("Reinvertir"));
					aportBean.setDesReinvertir(resultSet.getString("DesReinveritr"));
					aportBean.setPlazoOriginal(resultSet.getString("PlazoOriginal"));
					aportBean.setReinversion(resultSet.getString("Reinversion"));
					aportBean.setCajaRetiro(resultSet.getString("CajaRetiro"));
					aportBean.setMontosAnclados(resultSet.getString("MontosAnclados"));
					aportBean.setDiasPeriodo(resultSet.getString("DiasPeriodo"));
					aportBean.setPagoIntCal(resultSet.getString("PagoIntCal"));
					aportBean.setComentarios(resultSet.getString("Comentarios"));
					aportBean.setPerfilAutoriza(resultSet.getString("perfilAutoriza"));
					aportBean.setAportRenovada(resultSet.getString("AportacionRenovada"));
					aportBean.setMontoGlobal(resultSet.getString("MontoGlobal"));
					aportBean.setTasaMontoGlobal(resultSet.getString("TasaMontoGlobal"));
					aportBean.setIncluyeGpoFam(resultSet.getString("IncluyeGpoFam"));
					aportBean.setDiasPagoInt(resultSet.getString("DiasPago"));
					aportBean.setCapitaliza(resultSet.getString("PagoIntCapitaliza"));
					return aportBean;
				}
			});
			aportBean  = matches.size() > 0 ? (AportacionesBean) matches.get(0) : null;

		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en consulta de Aportaciones", e);
		}
		return aportBean;
	}


	public AportacionesBean consultaAnclaje(AportacionesBean aportBean, int tipoConsulta){
		AportacionesBean Aportaciones = null;
		try{
			String query = "call APORTACIONESCON(" +
					"?,?,?,?," +
					"?,?,?,?,?,?,?);";

			Object[] parametros = {
					Utileria.convierteEntero(aportBean.getAportacionID()),
					Constantes.ENTERO_CERO,
					Utileria.convierteEntero(aportBean.getClienteID()),
					tipoConsulta,

					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					"AportacionesDAO.consulta",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call APORTACIONESCON(" + Arrays.toString(parametros) +")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					AportacionesBean aportBean = new AportacionesBean();

					aportBean.setAportacionID(resultSet.getString(1));
					aportBean.setCuentaAhoID(resultSet.getString(2));
					aportBean.setTipoAportacionID(resultSet.getString(3));
					aportBean.setFechaVencimiento(resultSet.getString(4));
					aportBean.setMonto(resultSet.getString(5));

					aportBean.setTasaFija(resultSet.getString(6));
					aportBean.setEstatus(resultSet.getString(7));
					aportBean.setClienteID(resultSet.getString(8));
					aportBean.setMonedaID(resultSet.getString(9));
					aportBean.setPlazo(resultSet.getString(10));

					aportBean.setTasaBase(resultSet.getString(11));
					aportBean.setSobreTasa(resultSet.getString(12));
					aportBean.setPisoTasa(resultSet.getString(13));
					aportBean.setTechoTasa(resultSet.getString(14));
					aportBean.setCalculoInteres(resultSet.getString(15));

					aportBean.setPlazoOriginal(resultSet.getString(16));
					aportBean.setInteresGenerado(resultSet.getString(17));
					aportBean.setInteresRetener(resultSet.getString(18));
					aportBean.setInteresRecibir(resultSet.getString(19));
					aportBean.setValorGat(resultSet.getString(20));

					aportBean.setValorGatReal(resultSet.getString(21));
					aportBean.setAportacionMadreID(resultSet.getString(22));
					aportBean.setMontosAnclados(resultSet.getString(23));
					aportBean.setNuevaTasa(resultSet.getString(24));
					aportBean.setCajaRetiro(resultSet.getString(25));

					return aportBean;
				}
			});
			aportBean  = matches.size() > 0 ? (AportacionesBean) matches.get(0) : null;

		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en consulta de Aportaciones", e);
		}
		return aportBean;
	}

	public AportacionesBean consultaMontosAnclados(AportacionesBean aportBean, int tipoConsulta){
		AportacionesBean Aportaciones = null;
		try{
			String query = "call APORTACIONESCON(" +
					"?,?,?,?," +
					"?,?,?,?,?,?,?);";

			Object[] parametros = {
					Utileria.convierteEntero(aportBean.getAportacionID()),
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					tipoConsulta,

					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					"AportacionesDAO.consulta",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call APORTACIONESCON(" + Arrays.toString(parametros) +")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

					AportacionesBean aportBean = new AportacionesBean();

					aportBean.setMontosAnclados(resultSet.getString("MontosAnclados"));
					aportBean.setInteresesAnclados(resultSet.getString("InteresAnclados"));

					return aportBean;
				}
			});
			aportBean  = matches.size() > 0 ? (AportacionesBean) matches.get(0) : null;

		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en consulta de Aportaciones", e);
		}
		return aportBean;
	}


	public AportacionesBean AjusteAnclaje(AportacionesBean aportBean,int tipoConsulta){
		String query = "call APORTAJUSTECAL("
				+ "?,?,?,?,?,"
				+ "?,?,?,?,?,"
				+ "?,?,?,?,?);";
		Object[] parametros = {
				Utileria.convierteDoble(aportBean.getAportacionID()),
				aportBean.getTasa(),
				Utileria.convierteEntero(aportBean.getTasaBaseID()),
				Utileria.convierteDoble(aportBean.getSobreTasa()),
				Utileria.convierteDoble(aportBean.getPisoTasa()),

				Utileria.convierteDoble(aportBean.getTechoTasa()),
				Utileria.convierteEntero(aportBean.getCalculoInteres()),
				tipoConsulta,
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,

				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"AportacionesDAO.AjusteAnclaje",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
		};

		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call APORTAJUSTECAL(" + Arrays.toString(parametros).replace("[", "").replace("]", "") + ");");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				AportacionesBean aportBean = new AportacionesBean();
				aportBean.setInteresGenerado(resultSet.getString("InteresGenerado"));
				aportBean.setInteresRecibir(resultSet.getString("InteresRecibir"));
				aportBean.setInteresesAnclados(resultSet.getString("TotalInteres"));
				return aportBean;
			}
		});
		return matches.size() > 0 ? (AportacionesBean) matches.get(0) : null;
	}

	/*REPORTE DE APORTACIONES VENCIDAS*/
	public List listaReporteAportacionesVencidas(AportacionesBean aportBean,int tipoLista){
		List ListaAportacionesVencidas=null;
		try{
			String query="call APORTVENCIMIENREP(?,?,?,?,?,?,?,  ?,?,?,?,?,?,?);";

			Object[] parametros={
					aportBean.getFechaInicio(),
					aportBean.getFechaVencimiento(),
					aportBean.getAportacionID(),
					aportBean.getSucursalID(),
					aportBean.getPromotorID(),
					aportBean.getMonedaID(),
					aportBean.getEstatus(),

					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					"AportacionesDAO.listaReporteAportacionesVencidas",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO

			};

			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call APORTVENCIMIENREP(" + Arrays.toString(parametros) +")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					AportacionesBean aportBean = new AportacionesBean();

					aportBean.setSucursalID(resultSet.getString("SucursalID"));
					aportBean.setNombreSucursal(resultSet.getString("NombreSucurs"));
					aportBean.setNombrePromotor(resultSet.getString("NombrePromotor"));
					aportBean.setClienteID(resultSet.getString("ClienteID"));
					aportBean.setNombreCliente(resultSet.getString("NombreCompleto"));
					aportBean.setTipoAportacionID(resultSet.getString("TipoAportacionID"));
					aportBean.setDescripcion(resultSet.getString("DescripAportacion"));
					aportBean.setAportacionID(resultSet.getString("AportacionID"));
					aportBean.setFechaInicio(resultSet.getString("FechaInicio"));
					aportBean.setPlazo(resultSet.getString("Plazo"));
					aportBean.setFechaVencimiento(resultSet.getString("FechaVencimiento"));
					aportBean.setMonto(resultSet.getString("Monto"));
					aportBean.setCapital(resultSet.getString("Capital"));
					aportBean.setTasaFija(resultSet.getString("TasaFija"));
					aportBean.setTasaISR(resultSet.getString("TasaISR"));
					aportBean.setInteresGenerado(resultSet.getString("InteresGenerado"));
					aportBean.setInteresRetener(resultSet.getString("InteresRetener"));
					aportBean.setInteresRecibir(resultSet.getString("InteresRecibir"));
					aportBean.setTotalRecibir(resultSet.getString("TotalRecibir"));
					aportBean.setEstatus(resultSet.getString("Estatus"));

					aportBean.setTipoDocumento(resultSet.getString("TipoDocumento"));
					aportBean.setCantidad(resultSet.getString("Cantidad"));
					aportBean.setTipoDocReno(resultSet.getString("TipoDocReno"));
					aportBean.setCantidadReno(resultSet.getString("CantidadReno"));
					aportBean.setTotalReno(resultSet.getString("TotalReno"));
					aportBean.setTipoInteres(resultSet.getString("TipoInteres"));
					aportBean.setEspecificaciones(resultSet.getString("Especificaciones"));
					aportBean.setCondiciones(resultSet.getString("Condiciones"));

					aportBean.setPlazoOriginal(resultSet.getString("PlazoOriginal"));
					aportBean.setReinversionAutom(resultSet.getString("ReinversionAut"));
					aportBean.setNotas(resultSet.getString("Notas"));
					aportBean.setCuentaAhoID(resultSet.getString("Cuenta"));

					return aportBean;
				}
			});
			ListaAportacionesVencidas=matches;

		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en consulta de reporte de listaReporteAportacionesVencidas", e);
		}

		return ListaAportacionesVencidas;
	}

	/*REPORTE DE APORTACIONES VIGENTE*/
	public List listaReporteAportacionesVigentes(AportacionesBean aportBean,int tipoLista){
		List ListaAportacionesVigentes=null;
		transaccionDAO.generaNumeroTransaccion();
		try{
			String query="call APORTACIONESREP(?,?,?,?,?,?,?,?,   ?,?,?,?,?,?,?);";

			Object[] parametros={
					aportBean.getTipoAportacionID(),
					aportBean.getPromotorID(),
					aportBean.getSucursalID(),
					aportBean.getClienteID(),
					aportBean.getFechaApertura(),
					aportBean.getFinalDate(),
					aportBean.getEstatus(),
					aportBean.getNumReporte(),

					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					"AportacionesDAO.listaReporteAportacionesVencidas",
					Constantes.ENTERO_CERO,
					parametrosAuditoriaBean.getNumeroTransaccion()

			};

			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call APORTACIONESREP(" + Arrays.toString(parametros) +")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					AportacionesBean aportBean = new AportacionesBean();

					aportBean.setAportacionID(resultSet.getString("AportacionID"));
					aportBean.setTipoAportacionID(resultSet.getString("TipoAportacionID"));
					aportBean.setDescripcionTipoInv(resultSet.getString("DescripcionAportacion"));
					aportBean.setCuentaAhoID(resultSet.getString("CuentaAhoID"));
					aportBean.setClienteID(resultSet.getString("ClienteID"));
					aportBean.setFechaInicio(resultSet.getString("FechaInicio"));
					aportBean.setFechaVencimiento(resultSet.getString("FechaVencimiento"));
					aportBean.setMonto(resultSet.getString("Monto"));
					aportBean.setPlazo(resultSet.getString("Plazo"));
					aportBean.setTasaFija(resultSet.getString("TasaFija"));
					aportBean.setTasaISR(resultSet.getString("TasaISR"));
					aportBean.setEstatus(resultSet.getString("DescEstatus"));
					aportBean.setFechaApertura(resultSet.getString("FechaApertura"));
					aportBean.setTasa(resultSet.getString("TasaFV"));
					aportBean.setDesTipoAportacion(resultSet.getString("Descripcion"));
					aportBean.setCalculoInteres(resultSet.getString("CalculoInteres"));
					aportBean.setFormulaInteres(resultSet.getString("FormulaInteres"));
					aportBean.setSobreTasa(resultSet.getString("SobreTasa"));
					aportBean.setPisoTasa(resultSet.getString("PisoTasa"));
					aportBean.setTechoTasa(resultSet.getString("TechoTasa"));
					aportBean.setTasaBase(resultSet.getString("TasaBase"));
					aportBean.setDesTasaBase(resultSet.getString("TasaBaseDes"));
					aportBean.setNombreCompleto(resultSet.getString("NombreCompleto"));
					aportBean.setSucursalID(resultSet.getString("SucursalOrigen"));
					aportBean.setNombreSucursal(resultSet.getString("NombreSucurs"));
					aportBean.setPromotorID(resultSet.getString("PromotorActual"));
					aportBean.setNombrePromotor(resultSet.getString("NombrePromotor"));
					aportBean.setFechaAlta(resultSet.getString("FechaAlta"));
					aportBean.setInteres(resultSet.getString("InteresGenerado"));
					aportBean.setIsr(resultSet.getString("InteresRetener"));
					aportBean.setTotalRecibir(resultSet.getString("InteresRecibir"));
					aportBean.setTipoPagoInt(resultSet.getString("tipoPagoInt"));
					aportBean.setTasaBruta(resultSet.getString("TasaSugerida"));
					aportBean.setDescripcion(resultSet.getString("DiferenciaTasa"));
					aportBean.setOpcionAport(resultSet.getString("NombreCorto"));
					aportBean.setCantidadReno(resultSet.getString("Cantidad"));
					aportBean.setMontoGlobal(resultSet.getString("MontoGlobal"));
					aportBean.setDiasPagoInt(resultSet.getString("DiaPago"));
					aportBean.setReinversionAutom(resultSet.getString("ReinversionAut"));
					aportBean.setInstitucionUNO(resultSet.getString("InstitucionUno"));
					aportBean.setCuentaDestinoUNO(resultSet.getString("CuentaDestUno"));
					aportBean.setInstitucionDOS(resultSet.getString("InstitucionDos"));
					aportBean.setCuentaDestinoDOS(resultSet.getString("CuentaDestDos"));
					aportBean.setInstitucionTRES(resultSet.getString("InstitucionTres"));
					aportBean.setCuentaDestinoTRES(resultSet.getString("CuentaDestTres"));
					aportBean.setNotasNuevaAport(resultSet.getString("Notas"));

					aportBean.setFechaPrevencimiento(resultSet.getString("FechaVenAnt"));
//					aportBean.setEstatusAportacion(resultSet.getString("EstatusAportacion"));
					aportBean.setPlazoReal(resultSet.getString("PlazoOriginal"));
					aportBean.setMontoLiqAporAnterior(resultSet.getString("MontoLiqApoAnt"));
					aportBean.setInteresesProvIncremRenov(resultSet.getString("InteresIncRenov"));
					aportBean.setDineroNuevo(resultSet.getString("DineroNuevo"));
					aportBean.setIntPagadosPeriodo(resultSet.getString("InteresPagPeriodo"));
					aportBean.setIntDevNoPagadoPeriodo(resultSet.getString("InteresDevNoPagPeriodo"));
					aportBean.setIntDevPeriodo(resultSet.getString("InteresDevPeriodo"));
					aportBean.setIntDevMes(resultSet.getString("InteresDevMes"));
					aportBean.setMontoRenovado(resultSet.getString("MontoRenovado"));
					aportBean.setSaldoCapital(resultSet.getString("SaldoCap"));
					aportBean.setEspecificaciones(resultSet.getString("Especificaciones"));

					return aportBean;
				}
			});
			ListaAportacionesVigentes=matches;

		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en consulta de reporte de listaReporteAportacionesVencidas", e);
		}

		return ListaAportacionesVigentes;
	}


	/* VENCIMIENTO MASIVO Aportaciones*/
	public MensajeTransaccionBean vencimientoMasivoAportaciones(final AportacionesBean aportBean) {
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
									String query = "call APORTVENCMASIVOPRO(" +
											"?,?,?,?,?, ?,?,?,?,?," +
											"?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);
									sentenciaStore.setDate("Par_Fecha",OperacionesFechas.conversionStrDate(aportBean.getFechaInicio()));
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
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .AportacionesDAO.vencimientoMasivoAportaciones");
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

	/* ACTUALIZA EL VALOR DEL PROCESO DEL VENCIMIENTO MASIVO DE APORTACIONES*/
	public MensajeTransaccionBean actualizaProcesoAportaciones(final AportacionesBean aportBean,final int tipoActualizacion) {
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

	/* Validación para Aportaciones. */
	public MensajeTransaccionBean validaAportacion(final AportacionesBean aportBean) {
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
									String query = "call APORTACIONESVAL(?,?,?,	?,?,?,?,?,"
											+ "?,?,?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);

									sentenciaStore.setInt("Par_AportacionID", Utileria.convierteEntero(aportBean.getAportacionID()));
									sentenciaStore.setInt("Par_ProductoSAFI", Utileria.convierteEntero(aportBean.getProductoSAFI()));

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

									loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call APORTACIONESVAL "+ sentenciaStore.toString());
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
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .AportacionesDAO.validaAportacion");
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
						throw new Exception(Constantes.MSG_ERROR + " .AportacionesDAO.validaAportacion");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en la validacion de Aportaciones " + e);
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


	public AportacionesBean consultaVencimientoAnt(AportacionesBean aportBean, int tipoConsulta){
		AportacionesBean Aportaciones = null;
		try{
			String query = "call APORTACIONESCON(" +
					"?,?,?,?," +
					"?,?,?,?,?,?,?);";

			Object[] parametros = {
					Utileria.convierteEntero(aportBean.getAportacionID()),
					Constantes.ENTERO_CERO,
					Utileria.convierteEntero(aportBean.getClienteID()),
					tipoConsulta,

					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					"AportacionesDAO.consulta",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call APORTACIONESCON(" + Arrays.toString(parametros) +")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

					AportacionesBean aportBean = new AportacionesBean();
					aportBean.setAportacionID(String.valueOf(resultSet.getInt("AportacionID")));
					aportBean.setTipoAportacionID(resultSet.getString("TipoAportacionID"));
					aportBean.setCuentaAhoID(resultSet.getString("CuentaAhoID"));
					aportBean.setClienteID(resultSet.getString("ClienteID"));
					aportBean.setFechaInicio(resultSet.getString("FechaInicio"));
					aportBean.setFechaVencimiento(resultSet.getString("FechaVencimiento"));
					aportBean.setMonto(resultSet.getString("Monto"));
					aportBean.setPlazo(resultSet.getString("Plazo"));
					aportBean.setTasaFija(resultSet.getString("TasaFija"));
					aportBean.setTasaISR(resultSet.getString("TasaISR"));
					aportBean.setTasaNeta(resultSet.getString("TasaNeta"));
					aportBean.setInteresGenerado(resultSet.getString("InteresGenerado"));
					aportBean.setInteresRecibir(resultSet.getString("InteresRecibir"));
					aportBean.setSaldoProvision(resultSet.getString("SaldoProvision"));
					aportBean.setValorGat(resultSet.getString("ValorGat"));
					aportBean.setValorGatReal(resultSet.getString("ValorGatReal"));
					aportBean.setEstatusImpresion(resultSet.getString("EstatusImpresion"));
					aportBean.setMonedaID(resultSet.getString("MonedaID"));
					aportBean.setFechaVenAnt(resultSet.getString("FechaVenAnt"));
					aportBean.setEstatus(resultSet.getString("Estatus"));
					aportBean.setInteresRetener(resultSet.getString("InteresRetener"));
					aportBean.setTotalRecibir(resultSet.getString("TotalRecibir"));
					aportBean.setFechaApertura(resultSet.getString("FechaApertura"));
					aportBean.setSobreTasa(resultSet.getString("SobreTasa"));
					aportBean.setPisoTasa(resultSet.getString("PisoTasa"));
					aportBean.setTechoTasa(resultSet.getString("TechoTasa"));
					aportBean.setTipoPagoInt(resultSet.getString("TipoPagoInt"));
					aportBean.setTasaBase(resultSet.getString("TasaBase"));
					aportBean.setCalculoInteres(resultSet.getString("CalculoInteres"));
					aportBean.setPlazoOriginal(resultSet.getString("PlazoOriginal"));
					aportBean.setReinversion(resultSet.getString("Reinversion"));
					aportBean.setReinvertir(resultSet.getString("Reinvertir"));
					aportBean.setAportacionMadreID(resultSet.getString("AportMadreID"));
					aportBean.setCajaRetiro(resultSet.getString("CajaRetiro"));
					aportBean.setInicioPeriodo(resultSet.getString("AmorVig"));
					aportBean.setComentarios(resultSet.getString("Comentarios"));
					aportBean.setMontoGlobal(resultSet.getString("MontoGlobal"));
					aportBean.setTasaMontoGlobal(resultSet.getString("TasaMontoGlobal"));
					aportBean.setIncluyeGpoFam(resultSet.getString("IncluyeGpoFam"));
					aportBean.setDiasPagoInt(resultSet.getString("DiasPago"));
					aportBean.setCapitaliza(resultSet.getString("PagoIntCapitaliza"));
					aportBean.setOpcionAport(resultSet.getString("OpcionAport"));
					aportBean.setCantidadReno(resultSet.getString("CantidadReno"));
					aportBean.setInvRenovar(resultSet.getString("InvRenovar"));
					aportBean.setNotas(resultSet.getString("Notas"));
					aportBean.setExiste(resultSet.getString("Existe"));
					return aportBean;
				}
			});
			aportBean  = matches.size() > 0 ? (AportacionesBean) matches.get(0) : null;

		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en consulta de Aportaciones", e);
		}
		return aportBean;
	}
	/**
	 * Consulta el monto global del cliente y/o del grupo familiar del cliente.
	 * @param aportBean con los parámetros de entrada al SP-APORTACIONESCON.
	 * @param tipoConsulta 10.
	 * @return {@link AportacionesBean} con el monto global.
	 * @author avelasco
	 */
	public AportacionesBean consultaMontoGlobal(final AportacionesBean aportBean, final int tipoConsulta){
		AportacionesBean aportacionBean =null;
		try {
			aportacionBean = (AportacionesBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
					new CallableStatementCreator() {
						//Query con el Store Procedure
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
							String query = "call APORTACIONESCON(?,?,?,?," +
																"?,?,?,?,?,?,?);";

							CallableStatement sentenciaStore = arg0.prepareCall(query);

							sentenciaStore.setInt("Par_AportacionID",Utileria.convierteEntero(aportBean.getAportacionID()));
							sentenciaStore.setInt("Par_TipoAportacionID", Constantes.ENTERO_CERO);
							sentenciaStore.setInt("Par_ClienteID",Utileria.convierteEntero(aportBean.getClienteID()));
							sentenciaStore.setInt("Par_TipoConsulta",tipoConsulta);
							sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
							sentenciaStore.setInt("Par_UsuarioID", parametrosAuditoriaBean.getUsuario());

							sentenciaStore.setDate("Par_Fecha", parametrosAuditoriaBean.getFecha());
							sentenciaStore.setString("Par_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
							sentenciaStore.setString("Par_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
							sentenciaStore.setInt("Par_Sucursal",parametrosAuditoriaBean.getSucursal());
							sentenciaStore.setLong("Par_NumeroTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());

							loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());
							return sentenciaStore;
						}
					},new CallableStatementCallback() {
						public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,
						DataAccessException {
							AportacionesBean consultaBean = new AportacionesBean();
							if(callableStatement.execute()){
								ResultSet resultadosStore = callableStatement.getResultSet();

								resultadosStore.next();
								consultaBean.setMontoGlobal(resultadosStore.getString("MontoGlobal"));
							}
							return consultaBean;
						}
					});
			return aportacionBean;
		} catch (Exception e) {
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+" - "+"error en consulta de aportaciones monto global: ", e);
			return null;
		}
	}

	public AportacionesBean consultaMontoGlobalVencimiento(final AportacionesBean aportacionesBean, final int tipoConsulta){
		AportacionesBean aportacionBean =null;
		try {
			aportacionBean = (AportacionesBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
					new CallableStatementCreator() {
						//Query con el Store Procedure
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
							String query = "call APORTACIONESCON(?,?,?,?," +
																"?,?,?,?,?,?,?);";

							CallableStatement sentenciaStore = arg0.prepareCall(query);

							sentenciaStore.setInt("Par_AportacionID",Utileria.convierteEntero(aportacionesBean.getAportacionID()));
							sentenciaStore.setInt("Par_TipoAportacionID",Utileria.convierteEntero(aportacionesBean.getTipoAportacionID()));
							sentenciaStore.setInt("Par_ClienteID",Utileria.convierteEntero(aportacionesBean.getClienteID()));
							sentenciaStore.setInt("Par_TipoConsulta",tipoConsulta);
							sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
							sentenciaStore.setInt("Par_UsuarioID", parametrosAuditoriaBean.getUsuario());

							sentenciaStore.setDate("Par_Fecha", parametrosAuditoriaBean.getFecha());
							sentenciaStore.setString("Par_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
							sentenciaStore.setString("Par_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
							sentenciaStore.setInt("Par_Sucursal",parametrosAuditoriaBean.getSucursal());
							sentenciaStore.setLong("Par_NumeroTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());

							loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());
							return sentenciaStore;
						}
					},new CallableStatementCallback() {
						public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,
						DataAccessException {
							AportacionesBean consultaBean = new AportacionesBean();
							if(callableStatement.execute()){
								ResultSet resultadosStore = callableStatement.getResultSet();

								resultadosStore.next();
								consultaBean.setMontoGlobal(resultadosStore.getString("MontoGlobal"));
							}
							return consultaBean;
						}
					});
			return aportacionBean;
		} catch (Exception e) {
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+" - "+"error en consulta de aportaciones monto global al vencimiento: ", e);
			return null;
		}
	}
	/**
	 * Consulta para Validar la Consolidación de Aportaciones en Condiciones de Vencimiento.
	 * @param aportBean con los parámetros de entrada al SP-APORTACIONESCON.
	 * @param tipoConsulta 11.
	 * @return {@link AportacionesBean} con el resultado de la consulta.
	 * @author avelasco
	 */
	public AportacionesBean consultaConsolida(final AportacionesBean aportBean, final int tipoConsulta){
		AportacionesBean aportacionBean = null;
		try {
			aportacionBean = (AportacionesBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
					new CallableStatementCreator() {
						//Query con el Store Procedure
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
							String query = "call APORTACIONESCON(?,?,?,?,?,?,?,?,?,?,?);";

							CallableStatement sentenciaStore = arg0.prepareCall(query);

							sentenciaStore.setInt("Par_AportacionID",Utileria.convierteEntero(aportBean.getAportacionID()));
							sentenciaStore.setInt("Par_TipoAportacionID", Constantes.ENTERO_CERO);
							sentenciaStore.setInt("Par_ClienteID",Utileria.convierteEntero(aportBean.getClienteID()));
							sentenciaStore.setInt("Par_TipoConsulta",tipoConsulta);
							sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
							sentenciaStore.setInt("Par_UsuarioID", parametrosAuditoriaBean.getUsuario());

							sentenciaStore.setDate("Par_Fecha", parametrosAuditoriaBean.getFecha());
							sentenciaStore.setString("Par_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
							sentenciaStore.setString("Par_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
							sentenciaStore.setInt("Par_Sucursal",parametrosAuditoriaBean.getSucursal());
							sentenciaStore.setLong("Par_NumeroTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());

							loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());
							return sentenciaStore;
						}
					},new CallableStatementCallback() {
						public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,
						DataAccessException {
							AportacionesBean consultaBean = new AportacionesBean();
							if(callableStatement.execute()){
								ResultSet resultadosStore = callableStatement.getResultSet();

								resultadosStore.next();
								consultaBean.setAportacionID(resultadosStore.getString("AportacionID"));
								consultaBean.setClienteID(resultadosStore.getString("ClienteID"));
								consultaBean.setEstatus(resultadosStore.getString("Estatus"));
								consultaBean.setFechaVencimiento(resultadosStore.getString("FechaVencimiento"));
								consultaBean.setMonto(resultadosStore.getString("Monto"));
								consultaBean.setInteresGenerado(resultadosStore.getString("InteresGenerado"));
								consultaBean.setInteresRetener(resultadosStore.getString("InteresRetener"));
								consultaBean.setInteresRecibir(resultadosStore.getString("InteresRecibir"));
								consultaBean.setReinvertir(resultadosStore.getString("Reinvertir"));
								consultaBean.setExiste(resultadosStore.getString("Existe"));
								consultaBean.setTotalFinal(resultadosStore.getString("TotalFinal"));
							}
							return consultaBean;
						}
					});
			return aportacionBean;
		} catch (Exception e) {
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+" - "+"error en consulta de aportaciones monto global: ", e);
			return null;
		}
	}
	/**
	 * Método que trae la lista de resultados de Aportaciones que no han sido Autorizadas. Reporte de Aportaciones No Autorizadas.
	 * @param aportBean : Clase bean con los parámetros de entrada al SP-APORTACIONESPORAUTORIZARREP.
	 * @return List : Lista con el resultado del reporte.
	 * @author avelasco
	 */
	public List reporteAportacionesPorAurtorizar(AportacionesBean aportBean){
		List ListaAportaciones=null;
		try{
			String query="call APORTACIONESPORAUTORIZARREP(" +
					"?,?,?,?,?,		?,?,?,?,?,		" +
					"?);";

			Object[] parametros={
					Utileria.convierteEntero(aportBean.getTipoAportacionID()),
					Utileria.convierteEntero(aportBean.getPromotorID()),
					Utileria.convierteEntero(aportBean.getSucursalID()),
					Utileria.convierteEntero(aportBean.getClienteID()),
					Constantes.ENTERO_CERO,

					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					"AportacionesDAO.reporteAportacionesPorAurtorizar",
					Constantes.ENTERO_CERO,

					Constantes.ENTERO_CERO
			};

			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call APORTACIONESPORAUTORIZARREP(" + Arrays.toString(parametros) +");");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					AportacionesBean aportBean = new AportacionesBean();

					aportBean.setAportacionID(resultSet.getString("AportacionID"));
					aportBean.setClienteID(resultSet.getString("ClienteID"));
					aportBean.setNombreCliente(resultSet.getString("NombreCompleto"));
					aportBean.setTasaFija(resultSet.getString("Tasa"));
					aportBean.setTasaISR(resultSet.getString("TasaISR"));

					aportBean.setTasaNeta(resultSet.getString("TasaNeta"));
					aportBean.setMonto(resultSet.getString("Monto"));
					aportBean.setPlazo(resultSet.getString("Plazo"));
					aportBean.setFechaVencimiento(resultSet.getString("FechaVencimiento"));
					aportBean.setInteresGenerado(resultSet.getString("InteresGenerado"));

					aportBean.setInteresRetener(resultSet.getString("InteresRetener"));
					aportBean.setInteresRecibir(resultSet.getString("InteresRecibir"));
					aportBean.setEstatus(resultSet.getString("Estatus"));
					return aportBean;
				}
			});
			ListaAportaciones=matches;
		} catch(Exception e) {
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en consulta de reporte de Aportaciones Por Autorizar: ", e);
		}

		return ListaAportaciones;
	}

	//Lista de comentarios de aportaciones que cambiaron de tasa manualmente
	public List listaComentarios(AportacionesBean aportBean, int tipoLista) {
		//Query con el Store Procedure
		String query = "call CAMBIOTASAAPORTLIS(?,?,?,?, ?,?,?,?,?);";
		Object[] parametros = {
				aportBean.getAportacionID(),
				tipoLista,

				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				parametrosAuditoriaBean.getNombrePrograma(),
				parametrosAuditoriaBean.getSucursal(),
				Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CAMBIOTASAAPORTLIS(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				AportacionesBean aportaciones = new AportacionesBean();
				aportaciones.setDesComentarios(resultSet.getString("DesComentarios"));
				return aportaciones;
			}
		});
		return matches;
	}

	//Lista de opciones para cargar el combo de aportación en la pantalla alta aportación
		public List listaOpcionesAport(AportacionesBean aportBean, int tipoLista) {
			//Query con el Store Procedure
			String query = "call APORTACIONOPCIONESLIS(?,?,?, ?,?,?,?,?);";
			Object[] parametros = {
					tipoLista,

					parametrosAuditoriaBean.getEmpresaID(),
					parametrosAuditoriaBean.getUsuario(),
					parametrosAuditoriaBean.getFecha(),
					parametrosAuditoriaBean.getDireccionIP(),
					parametrosAuditoriaBean.getNombrePrograma(),
					parametrosAuditoriaBean.getSucursal(),
					Constantes.ENTERO_CERO};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call APORTACIONOPCIONESLIS(" + Arrays.toString(parametros) + ")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					AportacionesBean aportaciones = new AportacionesBean();
					aportaciones.setOpcionAport(resultSet.getString("Opcion"));
					aportaciones.setDescOpcionaport(resultSet.getString("Descripcion"));
					return aportaciones;
				}
			});
			return matches;
		}

		//REPORTE DE RENOVACIONES
				public List repRenovacion(final AportacionesBean aportacionesBean){
					List listaResultado=null;
					transaccionDAO.generaNumeroTransaccion();
					try{
						String query = "CALL APORTRENOVACIONESREP(?,?,?,?, ?,?,?,?,?,?,?)";

						Object[] parametros ={
							Utileria.convierteFecha(aportacionesBean.getFechaInicial()),
							Utileria.convierteFecha(aportacionesBean.getFechaFinal()),
							aportacionesBean.getEstatus(),
							Utileria.convierteEntero(aportacionesBean.getClienteID()),

				    		parametrosAuditoriaBean.getEmpresaID(),
							parametrosAuditoriaBean.getUsuario(),
							parametrosAuditoriaBean.getFecha(),
							parametrosAuditoriaBean.getDireccionIP(),
							parametrosAuditoriaBean.getNombrePrograma(),
							parametrosAuditoriaBean.getSucursal(),
							parametrosAuditoriaBean.getNumeroTransaccion()
						};

						loggerSAFI.info(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos()+"-"+"CALL APORTRENOVACIONESREP(  " + Arrays.toString(parametros) + ")");
						List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
							public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

								AportacionesBean bean = new AportacionesBean();

								bean.setAportacionID(resultSet.getString("AportacionID"));
								bean.setClienteID(resultSet.getString("ClienteID"));
								bean.setNombreCliente(resultSet.getString("NombreCompleto"));
								bean.setPlazo(resultSet.getString("PlazoOriginal"));
								bean.setFechaInicio(resultSet.getString("FechaInicio"));

								bean.setFechaVencimiento(resultSet.getString("FechaVencimiento"));
								bean.setMonto(resultSet.getString("MontoRenovacion"));
								bean.setTasa(resultSet.getString("TasaFija"));
								bean.setEstatus(resultSet.getString("EstatusRenovacion"));
								bean.setAportRenovada(resultSet.getString("AportacionRenovada"));

								bean.setMotivo(resultSet.getString("Motivo"));

								bean.setTipoRenovacion(resultSet.getString("TipoRenovacion"));
								bean.setTipoDocumento(resultSet.getString("TipoDocumento"));
								bean.setTipoInteres(resultSet.getString("TipoInteres"));

							return bean ;
							}
						});

						listaResultado= matches;

					}catch(Exception e){
						 e.printStackTrace();
						 loggerSAFI.error(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en reporte excel renovaciones.", e);
					}
					return listaResultado;
				}// fin lista report

	public void generaNumeroTransaccion(){
		transaccionDAO.generaNumeroTransaccion();
	}
		//Lista de de aportaciones por iniciar
		public List listaAportPorIniciar(AportacionesBean aportBean, int tipoLista) {
			List ListaAportaciones=null;
			try{
				String query="call APORTPORINICIARREP(" +
						"?,?,?,?,?,		?,?,?,?,?,		" +
						"?);";

				Object[] parametros={
						Utileria.convierteFecha(aportBean.getFechaInicio()),
						Utileria.convierteFecha(aportBean.getFechaVencimiento()),
						Utileria.convierteEntero(aportBean.getSucursalID()),
						Utileria.convierteEntero(aportBean.getClienteID()),
						Constantes.ENTERO_CERO,

						Constantes.ENTERO_CERO,
						Constantes.FECHA_VACIA,
						Constantes.STRING_VACIO,
						"AportacionesDAO.reporteAportacionesPorIniciar",
						Constantes.ENTERO_CERO,

						Constantes.ENTERO_CERO
				};

				loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call APORTPORINICIARREP(" + Arrays.toString(parametros) +");");
				List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
					public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
						AportacionesBean aportBean = new AportacionesBean();

						aportBean.setAportacionID(resultSet.getString("AportacionID"));
						aportBean.setNombrePromotor(resultSet.getString("NombrePromotor"));
						aportBean.setClienteID(resultSet.getString("ClienteID"));
						aportBean.setNombreCliente(resultSet.getString("NombreCompleto"));
						aportBean.setPlazo(resultSet.getString("Plazo"));
						aportBean.setFechaInicio(resultSet.getString("FechaInicio"));
						aportBean.setFechaVencimiento(resultSet.getString("FechaVencimiento"));
						aportBean.setMonto(resultSet.getString("Monto"));
						aportBean.setTasaFija(resultSet.getString("Tasa"));
						aportBean.setInteresRecibir(resultSet.getString("InteresRecibir"));
						aportBean.setInteresRetener(resultSet.getString("InteresRetener"));
						aportBean.setTipoPagoInt(resultSet.getString("TipoPagoInt"));
						aportBean.setCapitaliza(resultSet.getString("Capitaliza"));
						aportBean.setEstatus(resultSet.getString("Estatus"));
						aportBean.setMotivoCancela(resultSet.getString("MotivoCancela"));
						return aportBean;
					}
				});
				ListaAportaciones=matches;
			} catch(Exception e) {
				e.printStackTrace();
				loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en consulta de reporte de Aportaciones Por Autorizar: ", e);
			}

			return ListaAportaciones;
		}

		public ReciboAportContratoBean consultaReciboCapitaliza(int tipoConsulta, AportacionesBean aportaciones){
			ReciboAportContratoBean reciboBean = null;
			try{
				String query = "call APORTRECIBOCAPREP(" +
						"?,?,	?,?,?,?,?,?,?);";

				Object[] parametros = {
						Utileria.convierteEntero(aportaciones.getAportacionID()),
						tipoConsulta,

						Constantes.ENTERO_CERO,
						Constantes.ENTERO_CERO,
						Constantes.FECHA_VACIA,
						Constantes.STRING_VACIO,
						"AportacionesDAO.consultaReciboCapitaliza",
						Constantes.ENTERO_CERO,
						Constantes.ENTERO_CERO
				};
				loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call APORTRECIBOCAPREP(" + Arrays.toString(parametros) +")");
				List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
					public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
						ReciboAportContratoBean reciboAport = new ReciboAportContratoBean();

						reciboAport.setAportacionID(resultSet.getString("Var_NumRecibo"));
						reciboAport.setMonto(resultSet.getString("Var_MontoAport"));
						reciboAport.setMontoLetra(resultSet.getString("Var_MontoAportLetra"));
						reciboAport.setFechaSuscripcion(resultSet.getString("Var_FechaSuscrip"));
						reciboAport.setFechaVencimiento(resultSet.getString("Var_FechaVencim"));

						reciboAport.setNumRegistro(resultSet.getString("Var_NumRegistro"));
						reciboAport.setNombreAportante(resultSet.getString("Var_NombreAport"));
						reciboAport.setRepresentanteLegal(resultSet.getString("Var_RepLegalAport"));
						reciboAport.setDiaVencimNum(resultSet.getString("Var_DiaVencimNum"));
						reciboAport.setDiaVencimLetra(resultSet.getString("Var_DiaVencimLetra"));

						reciboAport.setMesAnioVencimLetra(resultSet.getString("Var_MesAnioVencim"));
						reciboAport.setAnioVencimLetra(resultSet.getString("Var_AnioLetraVencim"));
						reciboAport.setTasaNum(resultSet.getString("Var_TasaNum"));
						reciboAport.setTasaLetra(resultSet.getString("Var_TasaLetra"));
						reciboAport.setApoderado(resultSet.getString("Var_Representante"));

						reciboAport.setDireccionFiscal(resultSet.getString("Var_DirecInstit"));
						reciboAport.setTipoPersona(resultSet.getString("Var_TipoPersona"));

						return reciboAport;
					}
				});
				reciboBean  = matches.size() > 0 ? (ReciboAportContratoBean) matches.get(0) : null;

			}catch(Exception e){
				e.printStackTrace();
				loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en la generacion del recibo PREVICREM", e);
			}

			return reciboBean;
		}

	public ReciboAportContratoBean consultaReciboIrregular(int tipoConsulta, AportacionesBean aportaciones){
		ReciboAportContratoBean reciboBean = null;
		try{
			String query = "call APORTRECIBOCAPREP(" +
					"?,?,	?,?,?,?,?,?,?);";

			Object[] parametros = {
					Utileria.convierteEntero(aportaciones.getAportacionID()),
					tipoConsulta,

					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					"AportacionesDAO.consultaReciboIrregular",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call APORTRECIBOCAPREP(" + Arrays.toString(parametros) +")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					ReciboAportContratoBean reciboAport = new ReciboAportContratoBean();

					reciboAport.setAportacionID(resultSet.getString("Var_NumRecibo"));
					reciboAport.setMonto(resultSet.getString("Var_MontoAport"));
					reciboAport.setMontoLetra(resultSet.getString("Var_MontoAportLetra"));
					reciboAport.setFechaSuscripcion(resultSet.getString("Var_FechaSuscrip"));
					reciboAport.setFechaVencimiento(resultSet.getString("Var_FechaVencim"));

					reciboAport.setNumRegistro(resultSet.getString("Var_NumRegistro"));
					reciboAport.setNombreAportante(resultSet.getString("Var_NombreAport"));
					reciboAport.setRepresentanteLegal(resultSet.getString("Var_RepLegalAport"));
					reciboAport.setDiaVencimNum(resultSet.getString("Var_DiaVencimNum"));
					reciboAport.setDiaVencimLetra(resultSet.getString("Var_DiaVencimLetra"));

					reciboAport.setMesAnioVencimLetra(resultSet.getString("Var_MesAnioVencim"));
					reciboAport.setAnioVencimLetra(resultSet.getString("Var_AnioLetraVencim"));
					reciboAport.setTasaNum(resultSet.getString("Var_TasaNum"));
					reciboAport.setTasaLetra(resultSet.getString("Var_TasaLetra"));
					reciboAport.setApoderado(resultSet.getString("Var_Representante"));

					reciboAport.setDireccionFiscal(resultSet.getString("Var_DirecInstit"));
					reciboAport.setTipoPersona(resultSet.getString("Var_TipoPersona"));
					reciboAport.setNumPagos(resultSet.getString("Var_NumPagos"));
					reciboAport.setNumPagosLetra(resultSet.getString("Var_NumPagosLetra"));
					reciboAport.setIntBrutoPagoUNO(resultSet.getString("Var_IntBrutoPago1"));

					reciboAport.setIntBrutoPagoUNOLetra(resultSet.getString("Var_IntBrutoPago1Le"));
					reciboAport.setNumPagosRegulares(resultSet.getString("Var_NumPagosReg"));
					reciboAport.setNumPagosRegularesLetra(resultSet.getString("Var_NumPagosRegLet"));
					reciboAport.setMontoIntBruto(resultSet.getString("Var_MontoIntBrutoR"));
					reciboAport.setMontoIntBrutoLetra(resultSet.getString("Var_MontoIntBrutoRL"));

					reciboAport.setDiaPagoInteres(resultSet.getString("Var_DiaPagoInt"));
					reciboAport.setDiaPagoInteresLetra(resultSet.getString("Var_DiaPagoIntLet"));
					reciboAport.setDiaPrimerPagoInteres(resultSet.getString("Var_DiaPrimPagoInt"));
					reciboAport.setDiaPrimerPagoInteresLetra(resultSet.getString("Var_DiaPrimPagoInttLet"));
					reciboAport.setMesAnioPrimerPago(resultSet.getString("Var_MesAnioPrimPago"));

					reciboAport.setAnioPrimerPagoLetra(resultSet.getString("Var_AnioPrimPagLetra"));

					return reciboAport;
				}
			});
			reciboBean  = matches.size() > 0 ? (ReciboAportContratoBean) matches.get(0) : null;

		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en la generacion del recibo PREVICREM", e);
		}

		return reciboBean;
	}

	public ReciboAportContratoBean consultaReciboRegular(int tipoConsulta, AportacionesBean aportaciones){
		ReciboAportContratoBean reciboBean = null;
		try{
			String query = "call APORTRECIBOCAPREP(" +
					"?,?,	?,?,?,?,?,?,?);";

			Object[] parametros = {
					Utileria.convierteEntero(aportaciones.getAportacionID()),
					tipoConsulta,

					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					"AportacionesDAO.consultaReciboRegular",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call APORTRECIBOCAPREP(" + Arrays.toString(parametros) +")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					ReciboAportContratoBean reciboAport = new ReciboAportContratoBean();

					reciboAport.setAportacionID(resultSet.getString("Var_NumRecibo"));
					reciboAport.setMonto(resultSet.getString("Var_MontoAport"));
					reciboAport.setMontoLetra(resultSet.getString("Var_MontoAportLetra"));
					reciboAport.setFechaSuscripcion(resultSet.getString("Var_FechaSuscrip"));
					reciboAport.setFechaVencimiento(resultSet.getString("Var_FechaVencim"));

					reciboAport.setNumRegistro(resultSet.getString("Var_NumRegistro"));
					reciboAport.setNombreAportante(resultSet.getString("Var_NombreAport"));
					reciboAport.setRepresentanteLegal(resultSet.getString("Var_RepLegalAport"));
					reciboAport.setDiaVencimNum(resultSet.getString("Var_DiaVencimNum"));
					reciboAport.setDiaVencimLetra(resultSet.getString("Var_DiaVencimLetra"));

					reciboAport.setMesAnioVencimLetra(resultSet.getString("Var_MesAnioVencim"));
					reciboAport.setAnioVencimLetra(resultSet.getString("Var_AnioLetraVencim"));
					reciboAport.setTasaNum(resultSet.getString("Var_TasaNum"));
					reciboAport.setTasaLetra(resultSet.getString("Var_TasaLetra"));
					reciboAport.setApoderado(resultSet.getString("Var_Representante"));

					reciboAport.setDireccionFiscal(resultSet.getString("Var_DirecInstit"));
					reciboAport.setTipoPersona(resultSet.getString("Var_TipoPersona"));
					reciboAport.setNumPagos(resultSet.getString("Var_NumPagos"));
					reciboAport.setNumPagosLetra(resultSet.getString("Var_NumPagosLetra"));
					reciboAport.setIntBrutoPagoUNO(resultSet.getString("Var_IntBrutoPago1"));

					reciboAport.setIntBrutoPagoUNOLetra(resultSet.getString("Var_IntBrutoPago1Le"));
					reciboAport.setDiaPagoInteres(resultSet.getString("Var_DiaPagoInt"));
					reciboAport.setDiaPagoInteresLetra(resultSet.getString("Var_DiaPagoIntLet"));
					reciboAport.setDiaPrimerPagoInteres(resultSet.getString("Var_DiaPrimPagoInt"));
					reciboAport.setDiaPrimerPagoInteresLetra(resultSet.getString("Var_DiaPrimPagoInttLet"));

					reciboAport.setMesAnioPrimerPago(resultSet.getString("Var_MesAnioPrimPago"));
					reciboAport.setAnioPrimerPagoLetra(resultSet.getString("Var_AnioPrimPagLetra"));

					return reciboAport;
				}
			});
			reciboBean  = matches.size() > 0 ? (ReciboAportContratoBean) matches.get(0) : null;

		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en la generacion del recibo PREVICREM", e);
		}

		return reciboBean;
	}

	public ReciboAportContratoBean consultaTipoRecibo(AportacionesBean aportaciones){
		ReciboAportContratoBean reciboBean = null;
		int consulta = 1;
		try{
			String query = "call APORTCONVENIOREP(" +
					"?,?,	?,?,?,?,?,?,?);";

			Object[] parametros = {
					Utileria.convierteEntero(aportaciones.getAportacionID()),
					consulta,

					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					"AportacionesDAO.consultaTipoRecibo",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call APORTCONVENIOREP(" + Arrays.toString(parametros) +")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					ReciboAportContratoBean reciboAport = new ReciboAportContratoBean();

					reciboAport.setTipoRecibo(resultSet.getString("Var_TipoRecibo"));

					return reciboAport;
				}
			});
			reciboBean  = matches.size() > 0 ? (ReciboAportContratoBean) matches.get(0) : null;

		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en la generacion del recibo PREVICREM", e);
		}

		return reciboBean;
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

}
