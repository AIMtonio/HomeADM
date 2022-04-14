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

import operacionesCRCB.beanWS.request.DesembolsoCreditoRequest;
import operacionesCRCB.beanWS.response.DesembolsoCreditoResponse;

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
import credito.bean.CreditosBean;

public class DesembolsoCreditoDAO extends BaseDAO{

	PolizaDAO					polizaDAO				= null;
	ParametrosSisServicio		parametrosSisServicio	= null;
	ParametrosSesionBean 		parametrosSesionBean;

protected final Logger loggerSAFI = Logger.getLogger("SAFI");

	public DesembolsoCreditoDAO() {
		// TODO Auto-generated constructor stub
		super();
	}

	//Impresion Pagare-autorizacion y Desembolso de Credito
	public DesembolsoCreditoResponse desembolsoCred( final DesembolsoCreditoRequest requestBean) {

		DesembolsoCreditoResponse mensajeDesembolso = new DesembolsoCreditoResponse();
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		ParametrosSisBean parametrosSisBean	= new ParametrosSisBean();

		final PolizaBean polizaBean=new PolizaBean();
		final Long transaccion = parametrosAuditoriaBean.getNumeroTransaccion();
		int tipoConsulta = 7;

		parametrosSisBean = parametrosSisServicio.consulta(tipoConsulta, parametrosSisBean);

		// convertimos la fecha
		DateFormat fechaActual = new SimpleDateFormat("yyyy-MM-dd");
		String fechaConsulta = (parametrosSisBean.getFechaSistema().substring(0, 10));

		Date fechaSistema = null;
		try {

			fechaSistema = new Date (fechaActual.parse(fechaConsulta).getTime());

		} catch (ParseException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}

		parametrosSesionBean.setFechaSucursal(fechaSistema);
		polizaBean.setConceptoID(CreditosBean.desembolsoCredito);
		polizaBean.setConcepto(CreditosBean.desDesembolsoCredito);

		int	contador  = 0;
		while(contador <= PolizaBean.numIntentosGeneraPoliza){
			contador ++;
			polizaDAO.generaPolizaIDGenerico(polizaBean,transaccion);
			if (Utileria.convierteEntero(polizaBean.getPolizaID()) > 0){
				break;
			}
		}
		if (Utileria.convierteEntero(polizaBean.getPolizaID()) >0){
			mensajeDesembolso = (DesembolsoCreditoResponse) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
				public Object doInTransaction(TransactionStatus transaction) {
					DesembolsoCreditoResponse mensajeAlta = new DesembolsoCreditoResponse();

					String poliza =polizaBean.getPolizaID();
					try {

						mensajeAlta= desembolsoCreditoWS(polizaBean, requestBean,transaccion);

						if((Integer.parseInt(mensajeAlta.getCodigoRespuesta()) != 0 )){
							throw new Exception(mensajeAlta.getMensajeRespuesta());
						}
					} catch (Exception e) {
						if(mensajeAlta.getCodigoRespuesta().equals(Constantes.STRING_CERO)){
							mensajeAlta.setCodigoRespuesta("999");
						}
						mensajeAlta.setMensajeRespuesta(e.getMessage());
						transaction.setRollbackOnly();
						e.printStackTrace();
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en Desembolso de Credito", e);
					}
					return mensajeAlta;
				}
			});
			if(Integer.parseInt(mensajeDesembolso.getCodigoRespuesta())!=0){
				PolizaBean bajaPolizaBean = new PolizaBean();
				bajaPolizaBean.setTipo(PolizaDAO.Enum_TipoBajaPoliza.bajaPolizaId);
				bajaPolizaBean.setNumTransaccion(String.valueOf(Constantes.ENTERO_CERO));
				bajaPolizaBean.setPolizaID(polizaBean.getPolizaID());
				polizaDAO.bajaPoliza(bajaPolizaBean);

			}
		}else{
			mensajeDesembolso.setCodigoRespuesta("999");
			mensajeDesembolso.setMensajeRespuesta("El Número de Póliza se encuentra Vacio");
		}
		return mensajeDesembolso;
	}

	// aplicacion desembolso
	public DesembolsoCreditoResponse desembolsoCreditoWS(final PolizaBean bean,final DesembolsoCreditoRequest requestBean, final Long transaccion) {
		DesembolsoCreditoResponse mensaje = new DesembolsoCreditoResponse();
			mensaje = (DesembolsoCreditoResponse) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
				@SuppressWarnings("unchecked")
				public Object doInTransaction(TransactionStatus transaction) {
					DesembolsoCreditoResponse mensajeBean = new DesembolsoCreditoResponse();
					try{
						// Query con el Store Procedure
						mensajeBean = (DesembolsoCreditoResponse) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call CRCBDESCREDINDGRUPWSPRO(" +
												"?,?,?, ?,?,?,	?,?,?,?,?,?,?);";

									CallableStatement sentenciaStore = arg0.prepareCall(query);

									sentenciaStore.setLong("Par_CreditoID", Utileria.convierteLong(requestBean.getCreditoID()));
									sentenciaStore.setInt("Par_GrupoID", Utileria.convierteEntero(requestBean.getGrupoID()));
									sentenciaStore.setLong("Par_PolizaID",  Utileria.convierteLong(bean.getPolizaID()));

									sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

									sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
									sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
									sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
									sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
									sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
									sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
									sentenciaStore.setLong("Aud_NumTransaccion",transaccion);

									loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());

									return sentenciaStore;
								}
							},new CallableStatementCallback() {
								public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,
																												DataAccessException {
									DesembolsoCreditoResponse mensajeTransaccion = new DesembolsoCreditoResponse();
									if(callableStatement.execute()){
										ResultSet resultadosStore = callableStatement.getResultSet();

										resultadosStore.next();

										mensajeTransaccion.setCodigoRespuesta(resultadosStore.getString("NumErr"));
										mensajeTransaccion.setMensajeRespuesta(resultadosStore.getString("ErrMen"));


									}else{
										mensajeTransaccion.setCodigoRespuesta("999");
										mensajeTransaccion.setMensajeRespuesta("Fallo. El Procedimiento no Regreso Ningun Resultado.");
									}

									return mensajeTransaccion;
								}
							}
							);

						if(mensajeBean ==  null){
							mensajeBean = new DesembolsoCreditoResponse();
							mensajeBean.setCodigoRespuesta("999");
							throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
						}else if(Integer.parseInt(mensajeBean.getCodigoRespuesta())!=0){
							throw new Exception(mensajeBean.getMensajeRespuesta());
						}
					} catch (Exception e) {
						e.printStackTrace();
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Desembolso de Credito WS", e);
						if (mensajeBean.getCodigoRespuesta().equals(Constantes.STRING_CERO)) {
							mensajeBean.setCodigoRespuesta("999");
						}
						mensajeBean.setMensajeRespuesta(e.getMessage());
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
