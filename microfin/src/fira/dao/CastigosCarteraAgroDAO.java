package fira.dao;
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

import contabilidad.bean.PolizaBean;
import contabilidad.dao.PolizaDAO;
import fira.bean.CastigosCarteraAgroBean;
import fira.bean.CatReportesFIRABean;
import fira.bean.CreCastigosAgroRepBean;

public class CastigosCarteraAgroDAO extends BaseDAO {

	PolizaDAO polizaDAO = null;
	ParametrosSesionBean parametrosSesionBean;
	private final static String altaEnPolizaNo = "N";
	public CastigosCarteraAgroDAO() {
		super();
	}

	/* Registro de Castigo de Cartera */
	public MensajeTransaccionBean castigosCarteraAgro(final CastigosCarteraAgroBean castigosCarteraAgroBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		final PolizaBean polizaBean=new PolizaBean();

		polizaBean.setConceptoID(CastigosCarteraAgroBean.castigoCartera);
		polizaBean.setConcepto(CastigosCarteraAgroBean.desCastigoCartera);

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
					castigosCarteraAgroBean.setPolizaID(poliza);
					mensajeBean=castigosCartera(castigosCarteraAgroBean,parametrosAuditoriaBean.getNumeroTransaccion());
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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en castigos de cartera agro", e);
				}
				return mensajeBean;
			}
		});
		if(mensaje.getNumero() != 0){
			PolizaBean bajaPolizaBean = new PolizaBean();
			bajaPolizaBean.setTipo(PolizaDAO.Enum_TipoBajaPoliza.bajaPolizaId);
			bajaPolizaBean.setNumTransaccion(String.valueOf(Constantes.ENTERO_CERO));
			bajaPolizaBean.setPolizaID(polizaBean.getPolizaID());
			polizaDAO.bajaPoliza(bajaPolizaBean);
		}
	}else{
		mensaje.setNumero(999);
		mensaje.setDescripcion("El Número de Póliza se encuentra Vacio");
		mensaje.setNombreControl("numeroTransaccion");
		mensaje.setConsecutivoString("0");
	}
		return mensaje;
	}

	public MensajeTransaccionBean castigosCartera(final CastigosCarteraAgroBean castigosCarteraAgroBean,final long numTransaccion) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
						String query = "call CRECASTIGOFIRAPRO(?,?,?,?,?, ?,?,?,?,?,  ?,?,?,?,?,	?,?,?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);
								sentenciaStore.setLong("Par_CreditoID",Utileria.convierteLong(castigosCarteraAgroBean.getCreditoID()));
								sentenciaStore.setInt("Par_TipoCredCastigo",Utileria.convierteEntero(castigosCarteraAgroBean.getTipoCastigo()));
								sentenciaStore.setInt("Par_PolizaID", Utileria.convierteEntero(castigosCarteraAgroBean.getPolizaID()));
								sentenciaStore.setInt("Par_MotivoCastigoID",Utileria.convierteEntero(castigosCarteraAgroBean.getMotivoCastigoID()));
								sentenciaStore.setString("Par_Observaciones",castigosCarteraAgroBean.getObservaciones());
								sentenciaStore.setString("Par_TipoCastigo",castigosCarteraAgroBean.getTipoCastigo());
								sentenciaStore.setInt("Par_TipoCobranza", Utileria.convierteEntero(castigosCarteraAgroBean.getTipoCobranza()));
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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error Castigos de Cartera Agro", e);
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
				CastigosCarteraAgroBean castigosCarteraAgroBean = new CastigosCarteraAgroBean();
				castigosCarteraAgroBean.setMotivoCastigoID(String.valueOf(resultSet.getInt(1)));
				castigosCarteraAgroBean.setDescricpion(resultSet.getString(2));
				return castigosCarteraAgroBean;
			}
		});

		listaInstit =  matches;
	}catch(Exception e){
		e.printStackTrace();
	}
	return listaInstit;
	}


	/*Consulta Principal */
	public CastigosCarteraAgroBean consultaCastigoAgro(CastigosCarteraAgroBean castigosCarteraAgroBean, int tipoConsulta) {
		//Query con el Store Procedure
		String query = "call CRECASTIGOSCON(?,?, ?,?,?,?,?,?,?);";
		Object[] parametros = {
				castigosCarteraAgroBean.getCreditoID(),
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
				CastigosCarteraAgroBean castigosCartera = new CastigosCarteraAgroBean();

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
		return matches.size() > 0 ? (CastigosCarteraAgroBean) matches.get(0) : null;
	}

	/*Consulta para saber que Creditos se puede aplicar el Castigo (Contigente/Residual/Ambos) */
	public CastigosCarteraAgroBean consultaCreditoCastigoAgro(CastigosCarteraAgroBean castigosCarteraAgroBean, int tipoConsulta) {
		//Query con el Store Procedure
		String query = "call CRECASTIGOSCON(?,?, ?,?,?,?,?,?,?);";
		Object[] parametros = {
				castigosCarteraAgroBean.getCreditoID(),
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
				CastigosCarteraAgroBean castigosCartera = new CastigosCarteraAgroBean();

				castigosCartera.setAfectaGarantia(resultSet.getString("AfectaGaran"));
				castigosCartera.setCredResidualPag(resultSet.getString("CredResPag"));
				castigosCartera.setCredContigentePag(resultSet.getString("CredContPag"));


			    return castigosCartera;
			}


		});
		return matches.size() > 0 ? (CastigosCarteraAgroBean) matches.get(0) : null;
	}

	// metodo de consulta para validaciones ventanilla recuperacion de cartera castigada
	public String consultaMontoRecuperar(CastigosCarteraAgroBean castigosCarteraAgroBean, int tipoConsulta) {
		String montoRecuperar = "0";

		try{
			String query = "call CRECASTIGOSCON(?,?,  ?,?,?,?,?,?,?);";
			Object[] parametros = {	castigosCarteraAgroBean.getCreditoID(),
									tipoConsulta,

									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.FECHA_VACIA,
									Constantes.STRING_VACIO,
									"CastigosCarteraAgroDAO.ConsultaPrincipal",
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
	public List listaCarteraCastigada(final CreCastigosAgroRepBean castigosCarteraAgroBean, int tipoLista){
		List ListaResultado=null;

		try{
		String query = "call CRECASTIGOSAGROREP(?,?,?,?,?,  ?,?,?,?,?, ?,?,?)";

		Object[] parametros ={
							Utileria.convierteFecha(castigosCarteraAgroBean.getFechaInicio()),
							Utileria.convierteFecha(castigosCarteraAgroBean.getFechaFin()),
							Utileria.convierteEntero(castigosCarteraAgroBean.getSucursalID()),
							Utileria.convierteEntero(castigosCarteraAgroBean.getProducCreditoID()),
							Utileria.convierteEntero(castigosCarteraAgroBean.getPromotorID()),
							Utileria.convierteEntero(castigosCarteraAgroBean.getMotivoCastigoID()),


				    		parametrosAuditoriaBean.getEmpresaID(),
							parametrosAuditoriaBean.getUsuario(),
							parametrosAuditoriaBean.getFecha(),
							parametrosAuditoriaBean.getDireccionIP(),
							parametrosAuditoriaBean.getNombrePrograma(),
							parametrosAuditoriaBean.getSucursal(),
							Constantes.ENTERO_CERO};


		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CRECASTIGOSAGROREP(  " + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				CreCastigosAgroRepBean castigosCartera= new CreCastigosAgroRepBean();

				castigosCartera.setCreditoID(resultSet.getString("CreditoActivoID"));
				castigosCartera.setCreditoContID(resultSet.getString("CreditoContID"));
				castigosCartera.setTipoCredito(resultSet.getString("TipoCredito"));
				castigosCartera.setClienteID(resultSet.getString("ClienteID"));
				castigosCartera.setNombreCliente(resultSet.getString("NombreCompleto"));

				castigosCartera.setProducCreditoID(resultSet.getString("ProductoCreditoID"));
				castigosCartera.setDesProductoCred(resultSet.getString("DescProdCred"));
				castigosCartera.setGrupoID(resultSet.getString("GrupoID"));
				castigosCartera.setNombreGrupo(resultSet.getString("NombreGrupo"));
				castigosCartera.setMontoCredito(resultSet.getString("MontoOriginal"));

				castigosCartera.setFecha(resultSet.getString("FechaDesembolso"));
				castigosCartera.setFechaCastigo(resultSet.getString("FechaCastigo"));
				castigosCartera.setDescricpion(resultSet.getString("MotivoCastigo"));
				castigosCartera.setCapitalCastigado(resultSet.getString("CapitalCastigado"));
				castigosCartera.setInteresCastigado(resultSet.getString("InteresCastigado"));

				castigosCartera.setIntMoraCastigado(resultSet.getString("IntMoraCastigado"));
				castigosCartera.setAccesorioCastigado(resultSet.getString("ComisionesCastigado"));
				castigosCartera.setTotalCastigo(resultSet.getString("TotalCastigo"));
				castigosCartera.setMonRecuperado(resultSet.getString("MontoRecuperado"));
				castigosCartera.setMontoRecuperar(resultSet.getString("MontoRecuperar"));

				castigosCartera.setNombrePromotor(resultSet.getString("NombrePromotor"));
				castigosCartera.setNombreSucursal(resultSet.getString("NombreSucurs"));
				castigosCartera.setSucursalID(resultSet.getString("SucursalID"));
				castigosCartera.setNombrePromotor(resultSet.getString("PromotorActual"));
				castigosCartera.setHora(resultSet.getString("HoraEmision"));

				return castigosCartera ;
			}
		});
		ListaResultado= matches;
		}catch(Exception e){
			 e.printStackTrace();
			 loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en consulta de reprte de Creditos Agro Castigados", e);
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


