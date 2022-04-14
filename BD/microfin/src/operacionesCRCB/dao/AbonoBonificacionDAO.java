package operacionesCRCB.dao;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.Date;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.text.DateFormat;
import java.text.SimpleDateFormat;

import org.apache.log4j.Logger;
import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.CallableStatementCallback;
import org.springframework.jdbc.core.CallableStatementCreator;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;
import org.springframework.transaction.support.TransactionTemplate;

import contabilidad.bean.PolizaBean;
import contabilidad.dao.PolizaDAO;
import operacionesCRCB.beanWS.request.AbonoBonificacionRequest;
import operacionesCRCB.beanWS.response.AbonoBonificacionResponse;
import soporte.bean.ParametrosSisBean;
import soporte.servicio.ParametrosSisServicio;
import general.bean.MensajeTransaccionBean;
import general.bean.ParametrosSesionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

public class AbonoBonificacionDAO extends BaseDAO {
	PolizaDAO					polizaDAO				= null;
	ParametrosSisServicio		parametrosSisServicio	= null;
	ParametrosSesionBean 		parametrosSesionBean	= null;

	protected final Logger loggerSAFI = Logger.getLogger("SAFI");

	public AbonoBonificacionDAO() {
		super();
	}


	public AbonoBonificacionResponse abonoPorBonificacion(final AbonoBonificacionRequest abonoBonificacionRequest){
		AbonoBonificacionResponse abonoBonificacionResponse = new AbonoBonificacionResponse();
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		final PolizaBean polizaBean = new PolizaBean();

		String conceptoPolizaID = "31";
		String descConcepto	= "DEPOSITO POR BONIFICACION";

		transaccionDAO.generaNumeroTransaccion();

		try {
			int contador = 0;
			int tipoConsulta = 7;
			ParametrosSisBean parametrosSisBean = new ParametrosSisBean();

			parametrosSisBean = parametrosSisServicio.consulta(tipoConsulta, parametrosSisBean);

			DateFormat fechaActual = new SimpleDateFormat("yyyy-MM-dd");
			String fechaConsulta = (parametrosSisBean.getFechaSistema().substring(0, 10));

			polizaBean.setConceptoID(conceptoPolizaID);
			polizaBean.setConcepto(descConcepto);

			Date fechaSistema = null;

			fechaSistema = new Date(fechaActual.parse(fechaConsulta).getTime());

			parametrosSesionBean.setFechaSucursal(fechaSistema);

			while (contador <= PolizaBean.numIntentosGeneraPoliza) {
				contador++;
				mensaje = polizaDAO.generaPolizaIDGenerico(polizaBean, parametrosAuditoriaBean.getNumeroTransaccion());
				if (Utileria.convierteEntero(polizaBean.getPolizaID()) > 0) {
					break;
				}
			}

			if (Utileria.convierteEntero(polizaBean.getPolizaID()) > 0) {
				mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
					public Object doInTransaction(TransactionStatus transaction) {
						MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();

						try {
							mensajeBean = aplicaAbonoPorBonificacion(abonoBonificacionRequest, polizaBean);
							if (mensajeBean.getNumero() != 0) {
								throw new Exception(mensajeBean.getDescripcion());
							}
						}catch(Exception e){
							if (mensajeBean.getNumero() == 0) {
								mensajeBean.setNumero(999);
							}
							mensajeBean.setDescripcion(e.getMessage());
							transaction.setRollbackOnly();
							e.printStackTrace();
							loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "Error en el Abono por Bonificación", e);
						}
						return mensajeBean;
					}
				});
				if (mensaje.getNumero() != 0) {
					polizaDAO.bajaPoliza(polizaBean);
				}
				abonoBonificacionResponse.setCodigoRespuesta(String.valueOf(mensaje.getNumero()));
				abonoBonificacionResponse.setMensajeRespuesta(mensaje.getDescripcion());

			}else{
				mensaje.setNumero(999);
				mensaje.setDescripcion("Error al generar el numero de poliza");
			}
		}catch(Exception e){
			e.printStackTrace();
			if (mensaje == null) {
				mensaje = new MensajeTransaccionBean();
			}
			mensaje.setNumero(999);
			mensaje.setDescripcion("Ocurrió un error en el Abono por Bonificación");

			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "Ocurrió un error en el Abono por Bonificación", e);
		}

		return abonoBonificacionResponse;
	}


	@SuppressWarnings("unchecked")
	public MensajeTransaccionBean aplicaAbonoPorBonificacion(final AbonoBonificacionRequest request, final PolizaBean poliza){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();

		mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();

				try {
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
							String query = "call CRCBABONOBONIFICAWSPRO(?,?,?,?,?, 	?,?,?,?,?,	?,?,?,?,?, 	?,?);";
							CallableStatement sentenciaStore = arg0.prepareCall(query);

							sentenciaStore.setInt("Par_ClienteID", Utileria.convierteEntero(request.getClienteID()));
							sentenciaStore.setLong("Par_CuentaAhoID", Utileria.convierteLong(request.getCuentaID()));
							sentenciaStore.setDouble("Par_Monto", Utileria.convierteDoble(request.getMonto()));
							sentenciaStore.setInt("Par_Meses", Utileria.convierteEntero(request.getMeses()));
							sentenciaStore.setString("Par_TipoDispersion", request.getTipoDispersion());

							sentenciaStore.setString("Par_CuentaClabe", request.getCuentaClabe());
							sentenciaStore.setLong("Par_Poliza", Utileria.convierteLong(poliza.getPolizaID()));
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

				}catch(Exception e){
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "Error en Abono por Bonificación a cuenta WS", e);
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

	public ParametrosSisServicio getParametrosSisServicio() {
		return parametrosSisServicio;
	}

	public void setParametrosSisServicio(ParametrosSisServicio parametrosSisServicio) {
		this.parametrosSisServicio = parametrosSisServicio;
	}

	public ParametrosSesionBean getParametrosSesionBean() {
		return parametrosSesionBean;
	}

	public void setParametrosSesionBean(ParametrosSesionBean parametrosSesionBean) {
		this.parametrosSesionBean = parametrosSesionBean;
	}
}
