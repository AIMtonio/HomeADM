package operacionesCRCB.dao;

import general.bean.MensajeTransaccionBean;
import general.bean.ParametrosSesionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.Date;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;

import operacionesCRCB.bean.CargoAbonoCuentaBean;
import operacionesCRCB.beanWS.request.AbonoCuentaRequest;
import operacionesCRCB.beanWS.request.RetiroCuentaRequest;
import operacionesCRCB.beanWS.response.AbonoCuentaResponse;
import operacionesCRCB.beanWS.response.RetiroCuentaResponse;

import org.apache.log4j.Logger;
import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.CallableStatementCallback;
import org.springframework.jdbc.core.CallableStatementCreator;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;
import org.springframework.transaction.support.TransactionTemplate;

import soporte.bean.ParametrosSisBean;
import soporte.servicio.ParametrosSisServicio;

import contabilidad.bean.PolizaBean;
import contabilidad.dao.PolizaDAO;

public class CargoAbonoCuentaDAO extends BaseDAO {

	PolizaDAO					polizaDAO				= null;
	ParametrosSisServicio		parametrosSisServicio	= null;
	ParametrosSesionBean 		parametrosSesionBean;

	protected final Logger loggerSAFI = Logger.getLogger("SAFI");

	public CargoAbonoCuentaDAO(){
		super();
	}

	//Abono a Cuenta
	public AbonoCuentaResponse abonoCtaWS(final AbonoCuentaRequest requestBean) {
		AbonoCuentaResponse mensajeAbono = new AbonoCuentaResponse();

		try {
			Long transaccion = parametrosAuditoriaBean.getNumeroTransaccion();
			MensajeTransaccionBean mensajeGraba = new MensajeTransaccionBean();
			// Asignar los valores obtenidos al bean
			CargoAbonoCuentaBean bean = new CargoAbonoCuentaBean();
			PolizaBean polizaBean = new PolizaBean();

			bean.setCuentaAhoID(requestBean.getCuentaAhoID());
			bean.setMonto(requestBean.getMonto());
			bean.setNaturalezaMov("A");
			bean.setReferencia(requestBean.getReferencia());
			bean.setCodigoRastreo(requestBean.getCodigoRastreo());
			polizaBean.setConceptoID(CargoAbonoCuentaBean.conceptoAbonoCuenta);
			polizaBean.setConcepto(CargoAbonoCuentaBean.desAbonoCuenta);

			mensajeGraba = aplicaCargoAbonoCtaWS(bean, polizaBean, transaccion);

			if (mensajeGraba.getNumero() != 0) {
				mensajeAbono.setCodigoRespuesta(Integer.toString(mensajeGraba.getNumero()));
				mensajeAbono.setMensajeRespuesta(mensajeGraba.getDescripcion());

				bean.setNumeroError(Integer.toString(mensajeGraba.getNumero()));
				bean.setMensajeError(mensajeGraba.getDescripcion());
				mensajeGraba = AltaBitacora(bean, transaccion);

				throw new Exception(mensajeAbono.getMensajeRespuesta());

			} else {
				mensajeAbono.setCodigoRespuesta(Integer.toString(mensajeGraba.getNumero()));
				mensajeAbono.setMensajeRespuesta(mensajeGraba.getDescripcion());
				mensajeAbono.setNoTransaccion(Long.toString(transaccion));
			}

		} catch (Exception e) {
			e.printStackTrace();
			if (Integer.parseInt(mensajeAbono.getCodigoRespuesta()) == 0) {
				mensajeAbono.setCodigoRespuesta("999");
				mensajeAbono.setMensajeRespuesta("Estimado Usuario(a), Ha ocurrido una falla en el sistema, " + "estamos trabajando para resolverla. Disculpe las molestias que esto le ocasiona.");
			}
		}
		return mensajeAbono;
	}

	//Retiro de la Cuenta
	public RetiroCuentaResponse retiroCtaWS( final RetiroCuentaRequest requestBean) {

		RetiroCuentaResponse   mensajeAbono = new RetiroCuentaResponse();
		try{
			Long transaccion = parametrosAuditoriaBean.getNumeroTransaccion();
			MensajeTransaccionBean mensajeGraba = new MensajeTransaccionBean();
				// Asignar los valores obtenidos al bean
				CargoAbonoCuentaBean bean = new CargoAbonoCuentaBean();
			    PolizaBean polizaBean=new PolizaBean();

				bean.setCuentaAhoID(requestBean.getCuentaAhoID());
				bean.setMonto(requestBean.getMonto());
				bean.setNaturalezaMov("C");
				bean.setReferencia(Long.toString(transaccion) );
				polizaBean.setConceptoID(CargoAbonoCuentaBean.conceptoCargoCuenta);
				polizaBean.setConcepto(CargoAbonoCuentaBean.desRetiroCuenta);

				mensajeGraba = aplicaCargoAbonoCtaWS(bean, polizaBean, transaccion);

				if(mensajeGraba.getNumero() != 0 ){

					mensajeAbono.setCodigoRespuesta(Integer.toString(mensajeGraba.getNumero()));
					mensajeAbono.setMensajeRespuesta(mensajeGraba.getDescripcion());

					bean.setNumeroError(Integer.toString(mensajeGraba.getNumero()));
					bean.setMensajeError(mensajeGraba.getDescripcion());
					mensajeGraba = AltaBitacora(bean, transaccion);

					throw new Exception(mensajeAbono.getMensajeRespuesta());

				}else{
					mensajeAbono.setCodigoRespuesta(Integer.toString(mensajeGraba.getNumero()));
					mensajeAbono.setMensajeRespuesta(mensajeGraba.getDescripcion());
					mensajeAbono.setNoTransaccion(Long.toString(transaccion));
					}

		}catch (Exception e) {
				e.printStackTrace();
		 if(Integer.parseInt(mensajeAbono.getCodigoRespuesta()) == 0){
			 mensajeAbono.setCodigoRespuesta("999");
			 mensajeAbono.setMensajeRespuesta("Estimado Usuario(a), Ha ocurrido una falla en el sistema, "
						+ "estamos trabajando para resolverla. Disculpe las molestias que esto le ocasiona.");
		 	}
		}
		return mensajeAbono;
	}

	// Genera encabezado de poliza
	public MensajeTransaccionBean aplicaCargoAbonoCtaWS(final CargoAbonoCuentaBean bean, final PolizaBean polizaBean, final Long transaccion) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		try {
			ParametrosSisBean parametrosSisBean = new ParametrosSisBean();

			int tipoConsulta = 7;
			int contador = 0;

			parametrosSisBean = parametrosSisServicio.consulta(tipoConsulta, parametrosSisBean);

			// convertimos la fecha
			DateFormat fechaActual = new SimpleDateFormat("yyyy-MM-dd");
			String fechaConsulta = (parametrosSisBean.getFechaSistema().substring(0, 10));

			Date fechaSistema = null;
			try {

				fechaSistema = new Date(fechaActual.parse(fechaConsulta).getTime());

			} catch (ParseException e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}

			parametrosSesionBean.setFechaSucursal(fechaSistema);

			while (contador <= PolizaBean.numIntentosGeneraPoliza) {
				contador++;
				mensaje = polizaDAO.generaPolizaIDGenerico(polizaBean, transaccion);
				if (Utileria.convierteEntero(polizaBean.getPolizaID()) > 0) {
					break;
				}
			}
			if (Utileria.convierteEntero(polizaBean.getPolizaID()) > 0) {
				mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
					public Object doInTransaction(TransactionStatus transaction) {
						MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
						String poliza = polizaBean.getPolizaID();
						try {
							bean.setPolizaID(poliza);
							mensajeBean = aplicaCargoAbonoCtaWS(bean, transaccion);
							if (mensajeBean.getNumero() != 0) {
								throw new Exception(mensajeBean.getDescripcion());
							}
						}

						catch (Exception e) {
							if (mensajeBean.getNumero() == 0) {
								mensajeBean.setNumero(999);
							}
							mensajeBean.setDescripcion(e.getMessage());
							transaction.setRollbackOnly();
							e.printStackTrace();
							loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "error en Aono a Cuenta WS", e);
						}
						return mensajeBean;
					}
				});
				if (mensaje.getNumero() != 0) {
					PolizaBean bajaPolizaBean = new PolizaBean();
					bajaPolizaBean.setTipo(PolizaDAO.Enum_TipoBajaPoliza.bajaPolizaId);
					bajaPolizaBean.setNumTransaccion(String.valueOf(Constantes.ENTERO_CERO));
					bajaPolizaBean.setPolizaID(bean.getPolizaID());
					polizaDAO.bajaPoliza(bajaPolizaBean);

				}

			} else {
				mensaje.setNumero(999);
				mensaje.setDescripcion("El Número de Póliza se encuentra Vacio");
				mensaje.setNombreControl("numeroTransaccion");
				mensaje.setConsecutivoString("0");
			}
		} catch (Exception ex) {
			ex.printStackTrace();
			if (mensaje == null) {
				mensaje = new MensajeTransaccionBean();
				mensaje.setNumero(888);
			}
			mensaje.setDescripcion(ex.getMessage());
		}
		return mensaje;
	}

	public MensajeTransaccionBean aplicaCargoAbonoCtaWS(final CargoAbonoCuentaBean abonoCuentaBean, final Long transaccion) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			@SuppressWarnings("unchecked")
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
							String query = "call CRCBCARGOABONOCTAWSPRO(" + "?,?,?,?,?,		" + "?,?,?,?,?,		" + "?,?,?,?,?, ?);";
							CallableStatement sentenciaStore = arg0.prepareCall(query);
							if (abonoCuentaBean.getReferencia().equals(null) || abonoCuentaBean.getReferencia().trim().equalsIgnoreCase(Constantes.STRING_VACIO)) {
								abonoCuentaBean.setReferencia(transaccion + "");
							}

							sentenciaStore.setLong("Par_CuentaAhoID", Utileria.convierteLong(abonoCuentaBean.getCuentaAhoID()));
							sentenciaStore.setDouble("Par_Monto", Utileria.convierteDoble(abonoCuentaBean.getMonto()));
							sentenciaStore.setString("Par_NatMovimiento", abonoCuentaBean.getNaturalezaMov());
							sentenciaStore.setString("Par_Referencia", abonoCuentaBean.getReferencia());
                            sentenciaStore.setString("Par_CodigoRastreo", abonoCuentaBean.getCodigoRastreo());

							sentenciaStore.setLong("Par_Poliza", Utileria.convierteLong(abonoCuentaBean.getPolizaID()));

							sentenciaStore.setString("Par_Salida", Constantes.salidaSI);
							sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
							sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

							sentenciaStore.setInt("Par_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
							sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
							sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
							sentenciaStore.setString("Aud_DireccionIP", parametrosAuditoriaBean.getDireccionIP());
							sentenciaStore.setString("Aud_ProgramaID", parametrosAuditoriaBean.getNombrePrograma());
							sentenciaStore.setInt("Aud_Sucursal", parametrosAuditoriaBean.getSucursal());
							sentenciaStore.setLong("Aud_NumTransaccion", parametrosAuditoriaBean.getNumeroTransaccion());
							loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + sentenciaStore.toString());

							return sentenciaStore;
						}
					}, new CallableStatementCallback() {
						public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException, DataAccessException {

							MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();

							if (callableStatement.execute()) {
								ResultSet resultadosStore = callableStatement.getResultSet();

								resultadosStore.next();

								mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString("NumErr")).intValue());
								mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));

							} else {
								mensajeTransaccion.setNumero(999);
								mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.");
							}

							return mensajeTransaccion;
						}
					});

					if (mensajeBean == null) {
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
					} else if (mensajeBean.getNumero() != 0) {
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "Error en Abono a cuenta WS", e);
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

	public MensajeTransaccionBean AltaBitacora(final CargoAbonoCuentaBean abonoCuentaBean, final Long transaccion) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			@SuppressWarnings("unchecked")
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
							String query = "call BITACORACARABOALT(" + "?,?,?,?,?,		" + "?,?,?,?,?,		" + "?,?,?,?,?);";
							CallableStatement sentenciaStore = arg0.prepareCall(query);
							if (abonoCuentaBean.getReferencia().equals(null) || abonoCuentaBean.getReferencia().trim().equalsIgnoreCase(Constantes.STRING_VACIO)) {
								abonoCuentaBean.setReferencia(transaccion + "");
							}

							sentenciaStore.setLong("Par_CuentaAhoID", Utileria.convierteLong(abonoCuentaBean.getCuentaAhoID()));
							sentenciaStore.setDouble("Par_Monto", Utileria.convierteDoble(abonoCuentaBean.getMonto()));
							sentenciaStore.setInt("Par_NumeroError", Utileria.convierteEntero(abonoCuentaBean.getNumeroError()));
							sentenciaStore.setString("Par_MensajeError", abonoCuentaBean.getMensajeError());
							sentenciaStore.setLong("Par_Transaccion", parametrosAuditoriaBean.getNumeroTransaccion());

							sentenciaStore.setString("Par_Salida", Constantes.salidaSI);
							sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
							sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

							sentenciaStore.setInt("Par_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
							sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
							sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
							sentenciaStore.setString("Aud_DireccionIP", parametrosAuditoriaBean.getDireccionIP());
							sentenciaStore.setString("Aud_ProgramaID", parametrosAuditoriaBean.getNombrePrograma());
							sentenciaStore.setInt("Aud_Sucursal", parametrosAuditoriaBean.getSucursal());
							sentenciaStore.setLong("Aud_NumTransaccion", parametrosAuditoriaBean.getNumeroTransaccion());
							loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + sentenciaStore.toString());

							return sentenciaStore;
						}
					}, new CallableStatementCallback() {
						public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException, DataAccessException {

							MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();

							if (callableStatement.execute()) {
								ResultSet resultadosStore = callableStatement.getResultSet();

								resultadosStore.next();

								mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString("NumErr")).intValue());
								mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));

							} else {
								mensajeTransaccion.setNumero(999);
								mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Registra Ningun Dato.");
							}

							return mensajeTransaccion;
						}
					});

					if (mensajeBean == null) {
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception("Fallo. El Procedimiento no Registra Ningun Dato.");
					} else if (mensajeBean.getNumero() != 0) {
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "Error en Alta de Bitacora WS", e);
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


	public PolizaDAO getPolizaDAO() {
		return polizaDAO;
	}

	public void setPolizaDAO(PolizaDAO polizaDAO) {
		this.polizaDAO = polizaDAO;
	}

	public ParametrosSesionBean getParametrosSesionBean() {
		return parametrosSesionBean;
	}

	public void setParametrosSesionBean(ParametrosSesionBean parametrosSesionBean) {
		this.parametrosSesionBean = parametrosSesionBean;
	}

	public ParametrosSisServicio getParametrosSisServicio() {
		return parametrosSisServicio;
	}

	public void setParametrosSisServicio(ParametrosSisServicio parametrosSisServicio) {
		this.parametrosSisServicio = parametrosSisServicio;
	}



}
