package nomina.dao;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.Arrays;
import java.util.List;

import nomina.bean.TipoEmpleadosConvenioBean;

import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.CallableStatementCallback;
import org.springframework.jdbc.core.CallableStatementCreator;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;
import org.springframework.transaction.support.TransactionTemplate;

import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

public class TipoEmpleadosConvenioDAO extends BaseDAO{



	public MensajeTransaccionBean grabarTipoEmpleadoConv(final TipoEmpleadosConvenioBean tipoEmpleadosConvenioBean,final List listaTipoEmpleadosConv) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();

		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					TipoEmpleadosConvenioBean tipoEmplConv;


					for(int i=0; i<listaTipoEmpleadosConv.size(); i++){
						tipoEmplConv = (TipoEmpleadosConvenioBean)listaTipoEmpleadosConv.get(i);
						mensajeBean = altaTipoEmpleadoCon(tipoEmplConv);
						if(mensajeBean.getNumero()!=0){
							throw new Exception(mensajeBean.getDescripcion());
						}
					}
					mensajeBean.setNumero(0);
					mensajeBean.setDescripcion("Tipo Empleados Convenio agregado Exitosamente.");
					mensajeBean.setNombreControl("institNominaID");
					mensajeBean.setConsecutivoInt(mensajeBean.getConsecutivoInt());
				} catch (Exception e) {
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error de Tipo Empleados Convenio ", e);
					if(mensajeBean.getNumero()==0){
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


	public MensajeTransaccionBean altaTipoEmpleadoCon(final TipoEmpleadosConvenioBean tipoEmpleadosConvenioBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
	mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {

					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {

								String query = "call TIPOEMPLEADOSCONVENIOALT(?,?,?,?,?,  ?,?,?,?,?,  ?,?,?,?,? ,?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);

								sentenciaStore.setInt("Par_InstitNominaID",Utileria.convierteEntero(tipoEmpleadosConvenioBean.getInstitNominaID()));
								sentenciaStore.setInt("Par_ConvenioNominaID",Utileria.convierteEntero(tipoEmpleadosConvenioBean.getConvenioNominaID()));
								sentenciaStore.setInt("Par_TipoEmpleadoID",Utileria.convierteEntero(tipoEmpleadosConvenioBean.getTipoEmpleadoID()));
								sentenciaStore.setDouble("Par_SinTratamiento",Utileria.convierteDoble(tipoEmpleadosConvenioBean.getSinTratamiento()));
								sentenciaStore.setDouble("Par_ConTratamiento",Utileria.convierteDoble(tipoEmpleadosConvenioBean.getConTratamiento()));
								sentenciaStore.setString("Par_EstatusCheck",tipoEmpleadosConvenioBean.getSeleccionado());
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
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en la alta de Tipo Empleados Convenio", e);
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


	// Lista de los Convenios Activos por Institucion
		public List listaTipoEmplConv(TipoEmpleadosConvenioBean tipoEmpleadosConvenioBean, int tipoConsulta){
			List listaConvenio = null;
			try{
			String query = "call TIPOEMPLEADOSCONVENIOLIS(?,?,?,?,?, ?,?,?,?,?);";
			Object[] parametros = {
					Utileria.convierteEntero(tipoEmpleadosConvenioBean.getInstitNominaID()),
					Utileria.convierteEntero(tipoEmpleadosConvenioBean.getConvenioNominaID()),
					tipoConsulta,

					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					"TipoEmpleadosConvenioDAO.listaTipoEmplConv",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO
					};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TIPOEMPLEADOSCONVENIOLIS(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					TipoEmpleadosConvenioBean tipompleadosConvBean = new TipoEmpleadosConvenioBean();

					tipompleadosConvBean.setTipoEmpleadoID(resultSet.getString("TipoEmpleadoID"));
					tipompleadosConvBean.setDescripcion(resultSet.getString("Descripcion"));
					tipompleadosConvBean.setSinTratamiento(resultSet.getString("SinTratamiento"));
					tipompleadosConvBean.setConTratamiento(resultSet.getString("ConTratamiento"));
					tipompleadosConvBean.setSeleccionado(resultSet.getString("estatusCheck"));
					return tipompleadosConvBean;
				}
			});
		   listaConvenio = matches ;
			}
		   catch(Exception e){
				e.printStackTrace();
				loggerSAFI.error(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en lista de Convenios de Nómina", e);
			}
			return listaConvenio;
		}

		// Lista de Tipos de Empleados por Convenio de Nomina
				public List<?> listaTipoEmpleadoConvenio(TipoEmpleadosConvenioBean tipoEmpleadoBean,int tipoLista) {
					List<?> lista = null;
					try {
						String query = "CALL TIPOEMPLEADOSCONVENIOLIS (?,?,?,?,?, ?,?,?,?,?);";
						Object[] parametros = {
								Utileria.convierteEntero(tipoEmpleadoBean.getInstitNominaID()),
								Utileria.convierteEntero(tipoEmpleadoBean.getConvenioNominaID()),
								tipoLista,

								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"TipoEmpleadosConvenioDAO.listaTipoEmpleadoConvenio",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO};

						loggerSAFI.info(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos() + " - " + "CALL TIPOEMPLEADOSCONVENIOLIS (" + Arrays.toString(parametros) +")");
						List<?> matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper<Object>() {
							public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
								TipoEmpleadosConvenioBean resultado = new TipoEmpleadosConvenioBean();

								resultado.setTipoEmpleadoID(resultSet.getString("TipoEmpleadoID"));
								resultado.setDescripcion(resultSet.getString("Descripcion"));

								return resultado;
							}
						});
						lista = matches;
					} catch(Exception e) {
						loggerSAFI.error(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos() + " - " + "Error en lista de Tipos de Empleados por Convenio de Nómina.", e);
					}
					return lista;
				}


		//LISTA COMBO
		public List listaComboTipoEmpleados(TipoEmpleadosConvenioBean tipoEmpleadosConvenioBean, int tipoConsulta){
			List listaConvenio = null;
			try{
			String query = "call TIPOEMPLEADOSCONVENIOLIS(?,?,?,?,?, ?,?,?,?,?);";
			Object[] parametros = {
					Utileria.convierteEntero(tipoEmpleadosConvenioBean.getInstitNominaID()),
					Utileria.convierteEntero(tipoEmpleadosConvenioBean.getConvenioNominaID()),
					tipoConsulta,

					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					"TipoEmpleadosConvenioDAO.listaTipoEmplConv",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO
					};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TIPOEMPLEADOSCONVENIOLIS(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					TipoEmpleadosConvenioBean tipompleadosConvBean = new TipoEmpleadosConvenioBean();

					tipompleadosConvBean.setTipoEmpleadoID(resultSet.getString("TipoEmpleadoID"));
					tipompleadosConvBean.setDescripcion(resultSet.getString("Descripcion"));
					tipompleadosConvBean.setSinTratamiento(resultSet.getString("SinTratamiento"));
					tipompleadosConvBean.setConTratamiento(resultSet.getString("ConTratamiento"));
					tipompleadosConvBean.setSeleccionado(resultSet.getString("estatusCheck"));
					return tipompleadosConvBean;
				}
			});
		   listaConvenio = matches ;
			}
		   catch(Exception e){
				e.printStackTrace();
				loggerSAFI.error(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en lista de Convenios de Nómina", e);
			}
			return listaConvenio;
		}
}
