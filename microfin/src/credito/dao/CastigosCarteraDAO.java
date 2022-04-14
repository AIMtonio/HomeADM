package credito.dao;
import general.bean.MensajeTransaccionBean;
import general.bean.ParametrosSesionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
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

import contabilidad.bean.PolizaBean;
import contabilidad.dao.PolizaDAO;
import credito.bean.CastigosCarteraBean;
import credito.bean.CreCastigosRepBean;

public class CastigosCarteraDAO extends BaseDAO{
	PolizaDAO polizaDAO = null;
	ParametrosSesionBean parametrosSesionBean;
	private final static String altaEnPolizaNo = "N";
	public CastigosCarteraDAO() {
		super();
	}

	/* Registro de Castigo de Cartera */
	public MensajeTransaccionBean castigosCartera(final CastigosCarteraBean castigosCarteraBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		final PolizaBean polizaBean=new PolizaBean();

		polizaBean.setConceptoID(CastigosCarteraBean.castigoCartera);
		polizaBean.setConcepto(CastigosCarteraBean.desCastigoCartera);

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
					castigosCarteraBean.setPolizaID(poliza);
					mensajeBean=castigosCartera(castigosCarteraBean,parametrosAuditoriaBean.getNumeroTransaccion());
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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en castigos de cartera", e);
				}
				return mensajeBean;
			}
		});
	}else{
		mensaje.setNumero(999);
		mensaje.setDescripcion("El Número de Póliza se encuentra Vacio");
		mensaje.setNombreControl("numeroTransaccion");
		mensaje.setConsecutivoString("0");
	}
	return mensaje;
	}

	public MensajeTransaccionBean castigosCartera(final CastigosCarteraBean castigosCarteraBean,final long numTransaccion) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
						String query = "call CRECASTIGOPRO(?,?,?,?,?, ?,?,?,?,?,  ?,?,?,?,?,	?,?);";

								CallableStatement sentenciaStore = arg0.prepareCall(query);
								sentenciaStore.setLong("Par_CreditoID",Utileria.convierteLong(castigosCarteraBean.getCreditoID()));
								sentenciaStore.setInt("Par_PolizaID", Utileria.convierteEntero(castigosCarteraBean.getPolizaID()));
								sentenciaStore.setInt("Par_MotivoCastigoID",Utileria.convierteEntero(castigosCarteraBean.getMotivoCastigoID()));
								sentenciaStore.setString("Par_Observaciones",castigosCarteraBean.getObservaciones());
								sentenciaStore.setString("Par_TipoCastigo",castigosCarteraBean.getTipoCastigo());
								sentenciaStore.setInt("Par_TipoCobranza", Utileria.convierteEntero(castigosCarteraBean.getTipoCobranza()));
								sentenciaStore.setString("Par_AltaEncPoliza",altaEnPolizaNo);

								sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
								sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

								sentenciaStore.setInt("Aud_Usuario",parametrosAuditoriaBean.getUsuario());
								sentenciaStore.setDate("Aud_FechaActual",parametrosAuditoriaBean.getFecha());
								sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
								sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
								sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
								sentenciaStore.setLong("Aud_NumTransaccion",numTransaccion);

								loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());
								return sentenciaStore;
							} //public sql exception
						} // new CallableStatementCreator
						,new CallableStatementCallback() {
							public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,
																											DataAccessException {
								MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
								if(callableStatement.execute()){
									ResultSet resultadosStore = callableStatement.getResultSet();
									 resultadosStore.next();

									mensajeTransaccion.setNumero(Utileria.convierteEntero(resultadosStore.getString("NumErr")));
									mensajeTransaccion.setDescripcion(Utileria.generaLocale(resultadosStore.getString("ErrMen"), parametrosSesionBean.getNomCortoInstitucion()));
									mensajeTransaccion.setNombreControl(resultadosStore.getString("control"));
									mensajeTransaccion.setConsecutivoString(resultadosStore.getString("consecutivo"));
								}else{
									mensajeTransaccion.setNumero(999);
									mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.");
								}
								return mensajeTransaccion;
							}// public
						}// CallableStatementCallback
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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error Castigos de Cartera", e);
				mensajeBean.setDescripcion(e.getMessage());
				transaction.setRollbackOnly();

				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	/* combo motivos castigo */
	public List listaCombo(int tipoLista) {
		List listaInstit = null;
		try{
		//Query con el Store Procedure
		String query = "call MOTIVOSCASTIGOLIS(?,?,?, ?,?,?, ?,?);";
		Object[] parametros = {
				tipoLista,
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"CastigoCartera.listaCombo",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
				};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call MOTIVOSCASTIGOLIS(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				CastigosCarteraBean castigosCarteraBean = new CastigosCarteraBean();
				castigosCarteraBean.setMotivoCastigoID(String.valueOf(resultSet.getInt(1)));
				castigosCarteraBean.setDescricpion(resultSet.getString(2));
				return castigosCarteraBean;
			}
		});

		listaInstit =  matches;
	}catch(Exception e){
		e.printStackTrace();
	}
	return listaInstit;
	}


	/*Consulta Principal */
	public CastigosCarteraBean consultaCastigo(CastigosCarteraBean castigosCarteraBean, int tipoConsulta) {
		//Query con el Store Procedure
		String query = "call CRECASTIGOSCON(?,?, ?,?,?,?,?,?,?);";
		Object[] parametros = {
				castigosCarteraBean.getCreditoID(),
				tipoConsulta,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"CastigosCarteraDAO.consultaCastigo",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO};

		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CRECASTIGOSCON(  " + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				CastigosCarteraBean castigosCartera = new CastigosCarteraBean();

				castigosCartera.setCreditoID(resultSet.getString("CreditoID"));
				castigosCartera.setFecha(resultSet.getString("Fecha"));
				castigosCartera.setCapitalCastigado(resultSet.getString("CapitalCastigado"));
				castigosCartera.setInteresCastigado(resultSet.getString("InteresCastigado"));
				castigosCartera.setTotalCastigo(resultSet.getString("TotalCastigo"));

				castigosCartera.setMonRecuperado(resultSet.getString("MonRecuperado"));
				castigosCartera.setEstatusCredito(resultSet.getString("EstatusCredito"));
				castigosCartera.setMotivoCastigoID(resultSet.getString("MotivoCastigoID"));
				castigosCartera.setObservaciones(resultSet.getString("Observaciones"));
				castigosCartera.setIntMoraCastigado(resultSet.getString("IntMoraCastigado"));
				castigosCartera.setAccesorioCastigado(resultSet.getString("AccesorioCastigado"));
				castigosCartera.setIVA(resultSet.getString("IVA"));
				castigosCartera.setPorRecuperar(resultSet.getString("PorRecuperar"));


			    return castigosCartera;
			}


		});
		return matches.size() > 0 ? (CastigosCarteraBean) matches.get(0) : null;
	}

	// metodo de consulta para validaciones ventanilla recuperacion de cartera castigada
	public String consultaMontoRecuperar(CastigosCarteraBean castigosCarteraBean, int tipoConsulta) {
		String montoRecuperar = "0";

		try{
			String query = "call CRECASTIGOSCON(?,?,  ?,?,?,?,?,?,?);";
			Object[] parametros = {	castigosCarteraBean.getCreditoID(),
									tipoConsulta,

									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.FECHA_VACIA,
									Constantes.STRING_VACIO,
									"CastigosCarteraDAO.ConsultaPrincipal",
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CRECASTIGOSCON(" + Arrays.toString(parametros) + ")");

		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum)
						throws SQLException {
					String monto = new String();

					monto=resultSet.getString("PorRecuperar");
						return monto;
				}
			});
		montoRecuperar= matches.size() > 0 ? (String) matches.get(0) : "0";
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Consulta de Monto a recuperar", e);
		}
		return montoRecuperar;
	}


	//---------------------------REPORTES --------------------------------------------------
	public List listaCarteraCastigada(final CreCastigosRepBean castigosCarteraBean, int tipoLista){
		List ListaResultado=null;

		try{
		String query = "call CRECASTIGOSREP(?,?,?,?,?,  ?,?,?,?,?, ?,?,?,?,?,?)";

		Object[] parametros ={
							Utileria.convierteFecha(castigosCarteraBean.getFechaInicio()),
							Utileria.convierteFecha(castigosCarteraBean.getFechaFin()),
							Utileria.convierteEntero(castigosCarteraBean.getSucursalID()),
							Utileria.convierteEntero(castigosCarteraBean.getMonedaID()),
							Utileria.convierteEntero(castigosCarteraBean.getProducCreditoID()),
							Utileria.convierteEntero(castigosCarteraBean.getPromotorID()),
							Utileria.convierteEntero(castigosCarteraBean.getMotivoCastigoID()),
							Utileria.convierteEntero(castigosCarteraBean.getInstitucionNominaID()),
							Utileria.convierteEntero(castigosCarteraBean.getConvenioNominaID()),

				    		parametrosAuditoriaBean.getEmpresaID(),
							parametrosAuditoriaBean.getUsuario(),
							parametrosAuditoriaBean.getFecha(),
							parametrosAuditoriaBean.getDireccionIP(),
							parametrosAuditoriaBean.getNombrePrograma(),
							parametrosAuditoriaBean.getSucursal(),
							Constantes.ENTERO_CERO};


		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CRECASTIGOSREP(  " + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				CreCastigosRepBean castigosCartera= new CreCastigosRepBean();

				castigosCartera.setCreditoID(resultSet.getString("CreditoID"));
				castigosCartera.setClienteID(resultSet.getString("ClienteID"));
				castigosCartera.setNombreCliente(resultSet.getString("NombreCompleto"));
				castigosCartera.setProducCreditoID(resultSet.getString("ProductoCreditoID"));
				castigosCartera.setDesProductoCred(resultSet.getString("Descripcion"));

				castigosCartera.setGrupoID(resultSet.getString("GrupoID"));
				castigosCartera.setNombreGrupo(resultSet.getString("NombreGrupo"));
				castigosCartera.setMontoCredito(resultSet.getString("MontoCredito"));
				castigosCartera.setFecha(resultSet.getString("Fecha"));
				castigosCartera.setDescricpion(resultSet.getString("DesMotivoCastigo"));

				castigosCartera.setCapitalCastigado(resultSet.getString("CapitalCastigado"));
				castigosCartera.setInteresCastigado(resultSet.getString("InteresCastigado"));
				castigosCartera.setTotalCastigo(resultSet.getString("TotalCastigo"));
				castigosCartera.setMonRecuperado(resultSet.getString("MonRecuperado"));
				castigosCartera.setNombrePromotor(resultSet.getString("NombrePromotor"));

				castigosCartera.setNombreSucursal(resultSet.getString("NombreSucurs"));
				castigosCartera.setSucursalID(resultSet.getString("SucursalID"));
				castigosCartera.setNombrePromotor(resultSet.getString("PromotorActual"));
				castigosCartera.setMontoRecuperar(resultSet.getString("MontoRecuperar"));
				castigosCartera.setFechaMinistrado(resultSet.getString("FechaMinistrado"));
				castigosCartera.setHora(resultSet.getString("HoraEmision"));
				castigosCartera.setIntMoraCastigado(resultSet.getString("IntMoraCastigado"));
				castigosCartera.setAccesorioCastigado(resultSet.getString("AccesorioCastigado"));
				castigosCartera.setInstitucionNominaID(resultSet.getString("InstitucionNominaID"));
				castigosCartera.setConvenioNominaID(resultSet.getString("ConvenioNominaID"));
				castigosCartera.setMonNotasCrago(resultSet.getString("MontoNotasCargo"));


				return castigosCartera ;
			}
		});
		ListaResultado= matches;
		}catch(Exception e){
			 e.printStackTrace();
			 loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en consulta de reprte de Creditos Castigados", e);
		}
		return ListaResultado;
	}

	public ParametrosSesionBean getParametrosSesionBean() {
		return parametrosSesionBean;
	}

	public void setParametrosSesionBean(ParametrosSesionBean parametrosSesionBean) {
		this.parametrosSesionBean = parametrosSesionBean;
	}

	public PolizaDAO getPolizaDAO() {
		return polizaDAO;
	}

	public void setPolizaDAO(PolizaDAO polizaDAO) {
		this.polizaDAO = polizaDAO;
	}

}
