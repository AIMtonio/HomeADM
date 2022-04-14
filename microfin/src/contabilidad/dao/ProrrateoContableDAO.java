package contabilidad.dao;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;

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
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;

import contabilidad.bean.ProrrateoContableBean;
import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;

public class ProrrateoContableDAO extends BaseDAO{

	public ProrrateoContableDAO(){
		super();
	}

	public MensajeTransaccionBean alta(final ProrrateoContableBean prorrateoContableBean){
		final int insertaEncabezado=0;

		MensajeTransaccionBean mensaje=new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try{
					ArrayList centrosProrrateo = (ArrayList) hacerBeansProrrateo(prorrateoContableBean);
					if(!centrosProrrateo.isEmpty()){
						for(int i=0;i<centrosProrrateo.size();i++){
							final int ciclo=i;
							final ProrrateoContableBean prorrateoBean = (ProrrateoContableBean) centrosProrrateo.get(i);
							if(i!=0){
								prorrateoBean.setProrrateoID(mensajeBean.getConsecutivoString());
							}
			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
								new CallableStatementCreator() {
									public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
										String query = "call PRORRATEOCONTABLEALT (?,?,?,?,?,	?,?,?,?,?,	?,?,?,?,?,	?,?);";
										CallableStatement sentenciaStore = arg0.prepareCall(query);

										sentenciaStore.setInt("Par_ProrrateoID",Integer.parseInt(prorrateoBean.getProrrateoID()));
										sentenciaStore.setString("Par_NombreProrrateo",prorrateoBean.getNombreProrrateo());
										sentenciaStore.setString("Par_Estatus",prorrateoBean.getEstatus());
										sentenciaStore.setString("Par_Descripcion",prorrateoBean.getDescripcion());
										sentenciaStore.setInt("Par_CentroCostoID",Integer.parseInt(prorrateoBean.getCentroCostoID()));

										sentenciaStore.setFloat("Par_Porcentaje",Float.parseFloat(prorrateoBean.getPorcentaje()));
										sentenciaStore.setString("Par_Encabezado",(ciclo==insertaEncabezado?"S":"N"));
										sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
										sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
										sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

										sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
										sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
										sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
										sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
										sentenciaStore.setString("Aud_ProgramaID","CuentaNostroDAO.asignaChequesCaja");
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

											prorrateoContableBean.setProrrateoID(mensajeTransaccion.getConsecutivoString());
										}else{
											mensajeTransaccion.setNumero(999);
											mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .ProrrateoContableDAO.Alta");
											mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
											mensajeTransaccion.setConsecutivoString(Constantes.STRING_VACIO);
										}
										return mensajeTransaccion;
									}
								});
								if(mensajeBean ==  null){
									mensajeBean = new MensajeTransaccionBean();
									mensajeBean.setNumero(999);
									throw new Exception(Constantes.MSG_ERROR + " .ProrrateoContableDAO.Alta");
								}else if(mensajeBean.getNumero()!=0){
									throw new Exception(mensajeBean.getDescripcion());
								}

						}
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(0);
						mensajeBean.setDescripcion("Metodo Prorrateo Agregado Exitosamente");
						mensajeBean.setNombreControl("prorrateoID");
						mensajeBean.setConsecutivoString(prorrateoContableBean.getProrrateoID());
					}else{
					mensajeBean =new MensajeTransaccionBean();
					mensajeBean.setNumero(999);
					mensajeBean.setDescripcion("No Existen Participantes para el Prorrateo");
					}
				}catch(Exception e){
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error al Dar de Alta un Metodo Prorrateo Contable "+e);
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

	public MensajeTransaccionBean modifica(final ProrrateoContableBean prorrateoContableBean){
		final int insertaEncabezado=0;
		MensajeTransaccionBean mensaje=new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try{
					ArrayList centrosProrrateo = (ArrayList) hacerBeansProrrateo(prorrateoContableBean);
					if(!centrosProrrateo.isEmpty()){
						for(int i=0;i<centrosProrrateo.size();i++){
							final int ciclo=i;
							final ProrrateoContableBean prorrateoBean = (ProrrateoContableBean) centrosProrrateo.get(i);
			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
								new CallableStatementCreator() {
									public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
										String query = "call PRORRATEOCONTABLEMOD (?,?,?,?,?,	?,?,?,?,?,	?,?,?,?,?,	?,?);";
										CallableStatement sentenciaStore = arg0.prepareCall(query);

										sentenciaStore.setInt("Par_ProrrateoID",Integer.parseInt(prorrateoBean.getProrrateoID()));
										sentenciaStore.setString("Par_NombreProrrateo",prorrateoBean.getNombreProrrateo());
										sentenciaStore.setString("Par_Estatus",prorrateoBean.getEstatus());
										sentenciaStore.setString("Par_Descripcion",prorrateoBean.getDescripcion());
										sentenciaStore.setInt("Par_CentroCostoID",Integer.parseInt(prorrateoBean.getCentroCostoID()));

										sentenciaStore.setFloat("Par_Porcentaje",Float.parseFloat(prorrateoBean.getPorcentaje()));
										sentenciaStore.setString("Par_Encabezado",(ciclo==insertaEncabezado?"S":"N"));
										sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
										sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
										sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

										sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
										sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
										sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
										sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
										sentenciaStore.setString("Aud_ProgramaID","CuentaNostroDAO.asignaChequesCaja");
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
											mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString("NumErr")).intValue());
											mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
											mensajeTransaccion.setNombreControl(resultadosStore.getString("control"));
											mensajeTransaccion.setConsecutivoString(resultadosStore.getString("consecutivo"));

											//prorrateoContableBean.setProrrateoID(mensajeTransaccion.getConsecutivoInt());
										}else{
											mensajeTransaccion.setNumero(999);
											mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .ProrrateoContableDAO.Modificar");
											mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
											mensajeTransaccion.setConsecutivoString(Constantes.STRING_VACIO);
										}
										return mensajeTransaccion;
									}
								});
								if(mensajeBean ==  null){
									mensajeBean = new MensajeTransaccionBean();
									mensajeBean.setNumero(999);
									throw new Exception(Constantes.MSG_ERROR + " .ProrrateoContableDAO.Modificar");
								}else if(mensajeBean.getNumero()!=0){
									throw new Exception(mensajeBean.getDescripcion());
								}

						}

						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(0);
						mensajeBean.setDescripcion("Metodo Prorrateo Modificado Exitosamente");
						mensajeBean.setNombreControl("prorrateoID");
						//mensajeBean.setConsecutivoString(prorrateoContableBean.getProrrateoID());
					}else{
					mensajeBean =new MensajeTransaccionBean();
					mensajeBean.setNumero(999);
					mensajeBean.setDescripcion("No Existen Participantes para el Prorrateo");
					}
				}catch(Exception e){
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error al Modificar el Metodo Prorrateo Contable "+e);
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

	public ProrrateoContableBean consultaMetodo(int tipoConsulta,ProrrateoContableBean prorrateoContableBean){
		ProrrateoContableBean prorrateoBean = null;
		try{
			String query="CALL PRORRATEOCONTABLECON(?,?,?,?,?,	?,?,?,?)";
			Object [] parametros={
					prorrateoContableBean.getProrrateoID(),
					tipoConsulta,

					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					Constantes.STRING_VACIO,
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO
			};
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"CALL PRORRATEOCONTABLECON("+Arrays.toString(parametros)+")");
			@SuppressWarnings({ "unchecked", "rawtypes" })
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet,int numRow) throws SQLException{
					ProrrateoContableBean prorrateoConta=new ProrrateoContableBean();
					prorrateoConta.setProrrateoID(resultSet.getString("ProrrateoID"));
					prorrateoConta.setNombreProrrateo(resultSet.getString("NombreProrrateo"));
					prorrateoConta.setEstatus(resultSet.getString("Estatus"));
					prorrateoConta.setDescripcion(resultSet.getString("Descripcion"));
					return prorrateoConta;
				}
			});
			prorrateoBean= matches.size() > 0 ? (ProrrateoContableBean) matches.get(0) : null;
		}catch(Exception e){
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en el metodo consultaMetodo de ProrrateoContable "+e);
		}
		return prorrateoBean;
	}



	public List listaPrincipal(int tipoLista, ProrrateoContableBean prorrateoContableBean){
			List prorrateoContable=null;
			try{
				String query="CALL PRORRATEOCONTABLELIS(?,?,	?,?,?,?,?,?,?)";
				Object [] parametros ={
							prorrateoContableBean.getNombreProrrateo(),
							tipoLista,

							Constantes.ENTERO_CERO,
							Constantes.ENTERO_CERO,
							Constantes.FECHA_VACIA,
							Constantes.STRING_VACIO,
							Constantes.STRING_VACIO,
							Constantes.ENTERO_CERO,
							Constantes.ENTERO_CERO
				};
				loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"CALL PRORRATEOCONTABLELIS ("+Arrays.toString(parametros)+")");
				@SuppressWarnings({ "unchecked", "rawtypes" })
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
					public Object mapRow(ResultSet resultSet,int rowNum) throws SQLException{
						ProrrateoContableBean prorrateoContableBean = new ProrrateoContableBean();
						prorrateoContableBean.setProrrateoID(resultSet.getString("ProrrateoID"));
						prorrateoContableBean.setNombreProrrateo(resultSet.getString("NombreProrrateo"));
						return prorrateoContableBean;
					};
				});
				prorrateoContable=matches;
			}catch(Exception e){
				loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en grid de métodos de prorrateo contables", e);
			}
			return prorrateoContable;
	}

	public List hacerBeansProrrateo(ProrrateoContableBean prorrateo){
		String centrosID [] = prorrateo.getListaCentros().split(",");
		String porcentajeCentro[] = prorrateo.getPorcentajes().split(",");
		ArrayList prorrateoContable = new ArrayList();
		if(centrosID[0]!=""){
			for(int i=0;i<centrosID.length;i++){
				ProrrateoContableBean prorrateoBean = new ProrrateoContableBean();
				prorrateoBean.setProrrateoID(prorrateo.getProrrateoID());
				prorrateoBean.setNombreProrrateo(prorrateo.getNombreProrrateo());
				prorrateoBean.setEstatus(prorrateo.getEstatus());
				prorrateoBean.setDescripcion(prorrateo.getDescripcion());
				prorrateoBean.setCentroCostoID(centrosID[i]);
				prorrateoBean.setPorcentaje(porcentajeCentro[i]);

				prorrateoContable.add(prorrateoBean);
			}
		}
		return prorrateoContable;
	}


}
