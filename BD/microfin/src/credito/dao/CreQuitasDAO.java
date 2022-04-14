package credito.dao;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;

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
import org.springframework.jdbc.core.RowMapper;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;

import contabilidad.bean.PolizaBean;
import contabilidad.dao.PolizaDAO;
import credito.bean.CreQuitasBean;
import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.OperacionesFechas;
import herramientas.Utileria;

public class CreQuitasDAO extends BaseDAO{
	PolizaDAO polizaDAO	= null;

	public CreQuitasDAO() {
		super();
	}
	private final static String altaEnPolizaNo = "N";
	//Consulta numero de quitas que se llevan por credito
	public CreQuitasBean consultaNumQuitasXCredito(CreQuitasBean creQuitasBean, int tipoConsulta) {
		CreQuitasBean creQuitas = new CreQuitasBean();
		try{
			//Query con el Store Procedure
			String query = "call CREQUITASCON(?,?,?,?, ?,?,?,?,?,?,?);";
			Object[] parametros = {
					Utileria.convierteLong(creQuitasBean.getCreditoID()),
					Utileria.convierteEntero(creQuitasBean.getUsuarioID()),
					creQuitasBean.getPuestoID(),
					tipoConsulta,

					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					Constantes.STRING_VACIO,
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CREQUITASCON(  " + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					CreQuitasBean creQuitasBeanConsulta = new CreQuitasBean();
					creQuitasBeanConsulta.setNumQuitasCredito(resultSet.getString("NumQuitas"));
					return creQuitasBeanConsulta;
				}
			});
			creQuitas = matches.size() > 0 ? (CreQuitasBean) matches.get(0) : null;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en consulta de numeros de quitas", e);
		}
		return creQuitas;
	}

	/* SE MANDA A LLAMAR EL PROCESO QUE HACE LAS QUITAS DE CREDITOS*/
	public MensajeTransaccionBean procesoQuitasCredito(final CreQuitasBean creQuitasBean, final long numeroTransaccion) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "call CREQUITASPRO(" +
										"?,?,?,?,?, ?,?,?,?,?," +
										"?,?,?,?,?, ?,?,?,?,?," +
										"?,?,?,?,?,?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);
								sentenciaStore.setLong("Par_CreditoID",Utileria.convierteLong(creQuitasBean.getCreditoID()));
								sentenciaStore.setInt("Par_UsuarioID",Utileria.convierteEntero(creQuitasBean.getUsuarioID()));
								sentenciaStore.setString("Par_PuestoID",creQuitasBean.getPuestoID());
								sentenciaStore.setDate("Par_FechaRegistro",OperacionesFechas.conversionStrDate(creQuitasBean.getFechaRegistro()));
								sentenciaStore.setDouble("Par_MontoComisiones",Utileria.convierteDoble(creQuitasBean.getMontoComisiones()));

							    sentenciaStore.setDouble("Par_PorceComisiones",Utileria.convierteDoble(creQuitasBean.getPorceComisiones()));
								sentenciaStore.setDouble("Par_MontoMoratorios",Utileria.convierteDoble(creQuitasBean.getMontoMoratorios()));
								sentenciaStore.setDouble("Par_PorceMoratorios",Utileria.convierteDoble(creQuitasBean.getPorceMoratorios()));
								sentenciaStore.setDouble("Par_MontoInteres",Utileria.convierteDoble(creQuitasBean.getMontoInteres()));
								sentenciaStore.setDouble("Par_PorceInteres",Utileria.convierteDoble(creQuitasBean.getPorceInteres()));

								sentenciaStore.setDouble("Par_MontoCapital",Utileria.convierteDoble(creQuitasBean.getMontoCapital()));
								sentenciaStore.setDouble("Par_PorceCapital",Utileria.convierteDoble(creQuitasBean.getPorceCapital()));
								sentenciaStore.setDouble("Par_MontoNotasCargo",Utileria.convierteDoble(creQuitasBean.getMontoNotasCargo()));
								sentenciaStore.setDouble("Par_PorceNotasCargo",Utileria.convierteDoble(creQuitasBean.getPorceNotasCargos()));

								sentenciaStore.setInt("Par_Poliza",Utileria.convierteEntero(creQuitasBean.getPolizaID()));
								sentenciaStore.setString("Par_AltaPoliza",altaEnPolizaNo);

							    sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

								sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
								sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
								sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
								sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
								sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
								sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
								sentenciaStore.setLong("Aud_NumTransaccion",numeroTransaccion);
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
									mensajeTransaccion.setConsecutivoInt(resultadosStore.getString(4));
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
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en proceso de quitas de credito", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	/* SE MANDA A LLAMAR EL PROCESO QUE HACE LAS QUITAS DE CREDITOS*/
	public MensajeTransaccionBean quitasCredito(final CreQuitasBean creQuitasBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		final PolizaBean polizaBean=new PolizaBean();

		polizaBean.setConceptoID(CreQuitasBean.conceptoCondonaCartera);
		polizaBean.setConcepto(CreQuitasBean.desConceptoCondonaCartera);

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
						creQuitasBean.setPolizaID(poliza);
						mensajeBean = procesoQuitasCredito(creQuitasBean,parametrosAuditoriaBean.getNumeroTransaccion());
							if(mensajeBean.getNumero()!=0){
								throw new Exception(mensajeBean.getDescripcion());
						}
						}
					 catch (Exception e) {
						if(mensajeBean.getNumero()==0){
							mensajeBean.setNumero(999);
						}
						mensajeBean.setDescripcion(e.getMessage());
						transaction.setRollbackOnly();
						e.printStackTrace();
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en proceso de quitas de credito", e);
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

	public List consultaCreQuitasReo(CreQuitasBean creQuitasBean, int tipoLista) {
		// TODO Auto-generated method stub
		List listaResultado = null;

		try{
		String query = "call CREQUITASREP(?,?,?,?,?  ,?,?,?,?,?,	?,?,?,? )";
		Object[] parametros ={
				Utileria.convierteFecha(creQuitasBean.getFechaInicio()),
				Utileria.convierteFecha(creQuitasBean.getFechaFin()),
				Utileria.convierteEntero(creQuitasBean.getSucursal()),
				Utileria.convierteEntero(creQuitasBean.getProducCreditoID()),
				Utileria.convierteEntero(creQuitasBean.getCreditoID()),
				Utileria.convierteEntero(creQuitasBean.getInstitucionNominaID()),
				Utileria.convierteEntero(creQuitasBean.getConvenioNominaID()),

				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				"CreQuitasDAO.consultaCreQuitasReo",
				parametrosAuditoriaBean.getSucursal(),
				Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CREQUITASREP(  " + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				CreQuitasBean creQuitas= new CreQuitasBean();

				creQuitas.setFechaRegistro(resultSet.getString("FechaRegistro"));
				creQuitas.setGrupoID(resultSet.getString("GrupoID"));
				creQuitas.setCreditoID(resultSet.getString("CreditoID"));
				creQuitas.setClienteID(resultSet.getString("ClienteID"));
				creQuitas.setNomCliente(resultSet.getString("NombreCliente"));

				creQuitas.setProducCreditoID(resultSet.getString("ProductoCreditoID"));
				creQuitas.setNombreProducto(resultSet.getString("ProductoDesc"));
				creQuitas.setSucursal(resultSet.getString("SucursalID"));
				creQuitas.setNombreSucursal(resultSet.getString("NombreSucurs"));
				creQuitas.setMontoCredito(resultSet.getString("MontoCredito"));
				creQuitas.setNombreUsuario(resultSet.getString("NombreUsuario"));
				creQuitas.setUsuarioID(resultSet.getString("UsuarioID"));
				creQuitas.setPuestoID(resultSet.getString("PuestoID"));
				creQuitas.setMontoCapital(resultSet.getString("MontoCapital"));
				creQuitas.setMontoInteres(resultSet.getString("MontoInteres"));
				creQuitas.setMontoMoratorios(resultSet.getString("MontoMoratorios"));
				creQuitas.setMontoComisiones(resultSet.getString("MontoComisiones"));
				creQuitas.setTotalCondonado(resultSet.getString("TotalCondonado"));
				creQuitas.setNombreGrupo(resultSet.getString("NombreGrupo"));
				creQuitas.setClaveUsuario(resultSet.getString("ClaveUsuario"));
				creQuitas.setInstitucionNominaID(resultSet.getString("InstitucionNominaID"));
				creQuitas.setConvenioNominaID(resultSet.getString("ConvenioNominaID"));
				creQuitas.setMontoNotasCargo(resultSet.getString("MontoNotasCargo"));
				return creQuitas ;
			}
		});
		listaResultado= matches;
		}catch(Exception e){
			 e.printStackTrace();
			 loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en consulta de reporte de CreditoQuitas", e);
		}
		return listaResultado;
	}

	public PolizaDAO getPolizaDAO() {
		return polizaDAO;
	}

	public void setPolizaDAO(PolizaDAO polizaDAO) {
		this.polizaDAO = polizaDAO;
	}




}
