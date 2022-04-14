package ventanilla.dao;
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

import ventanilla.bean.CajasVentanillaBean;
import ventanilla.bean.CatalogoGastosAntBean;
import ventanilla.bean.ReversasOperBean;
import ventanilla.bean.ReversasOperCajaBean;
import general.bean.MensajeTransaccionBean;
import general.bean.ParametrosSesionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.OperacionesFechas;
import herramientas.Utileria;


public class ReversasOperCajaDAO extends BaseDAO{
	ParametrosSesionBean parametrosSesionBean;

	public ReversasOperCajaDAO(){
		super();
	}
	
	// ------------ reporte opVentanilla
	public List consultaReversas(final ReversasOperCajaBean reversasOperCajaBean){

		List listaOpVentanilla=null;
		List matches =new  ArrayList();
		final List matches2 =new  ArrayList();
		try{
			matches =(List) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
new CallableStatementCreator() {
			public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
				String query = "call REVERSASOPERREP(" +
						"?,?,?,?,?, ?,?,?,?,?,?);";
				CallableStatement sentenciaStore = arg0.prepareCall(query);
				sentenciaStore.setString("Par_FechaInicial",reversasOperCajaBean.getFechaIni());
				sentenciaStore.setString("Par_FechaFinal",reversasOperCajaBean.getFechaFin());
				sentenciaStore.setInt("Par_Sucursal",Utileria.convierteEntero(reversasOperCajaBean.getSucursalID()));
				sentenciaStore.setInt("Par_CajaID",Utileria.convierteEntero(reversasOperCajaBean.getCajaID()));
				
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
				public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,DataAccessException {
					if(callableStatement.execute()){																		
						ResultSet resultadosStore = callableStatement.getResultSet();
						while (resultadosStore.next()) { 	
							ReversasOperCajaBean reversasOperCajaBean	=new ReversasOperCajaBean();
							reversasOperCajaBean.setSucursalID(Utileria.completaCerosIzquierda(resultadosStore.getString(1),3));
							reversasOperCajaBean.setNombreSucursal(resultadosStore.getString(2));
							reversasOperCajaBean.setCajaID(Utileria.completaCerosIzquierda(resultadosStore.getString(3),3));
							reversasOperCajaBean.setFecha(resultadosStore.getString(4));
							reversasOperCajaBean.setClave(resultadosStore.getString(5));
							reversasOperCajaBean.setClaveUsuarioAut(resultadosStore.getString(6));
							reversasOperCajaBean.setHora(resultadosStore.getString(7));
							reversasOperCajaBean.setDescripcion(resultadosStore.getString(8));
							reversasOperCajaBean.setMotivo(resultadosStore.getString(9));
							reversasOperCajaBean.setReferencia(resultadosStore.getString(10));
							reversasOperCajaBean.setMonto(String.valueOf(resultadosStore.getDouble(11)));
							reversasOperCajaBean.setTransaccion(resultadosStore.getString(12));
							reversasOperCajaBean.setDescripcionCaja(resultadosStore.getString(13));
							
							
						matches2.add(reversasOperCajaBean);
					}	 
				}
				return matches2;
			}
			});
				}catch(Exception e){
					e.printStackTrace();
					}
		return matches;
					
		}
	
	//	CONSULTA PRINCIPAL
	public ReversasOperBean consultaPrincipal(ReversasOperBean reversasOperBean, int tipoConsulta){
		ReversasOperBean consultaBean = null;
		try {
			String query = "call REVERSASOPERCON(?,?, ?,?,?,?,?,?,?);";
			Object[] parametros = { 
					reversasOperBean.getTransaccionID(),
					tipoConsulta,
					
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					OperacionesFechas.FEC_VACIA,
					Constantes.STRING_VACIO,
					"consultaTransaccionReversa",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call REVERSASOPERCON(" + Arrays.toString(parametros) +")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum)
						throws SQLException {
					ReversasOperBean reversasOperBean = new ReversasOperBean();
					
					reversasOperBean.setTransaccionID(resultSet.getString("TransaccionID"));
					reversasOperBean.setMotivo(resultSet.getString("Motivo"));
					reversasOperBean.setDescripcionOper(resultSet.getString("DescripcionOper"));
					reversasOperBean.setTipoOperacion(resultSet.getString("TipoOperacion"));
					reversasOperBean.setReferencia(resultSet.getString("Referencia"));
					
					reversasOperBean.setMonto(resultSet.getString("Monto"));
					reversasOperBean.setCajaID(resultSet.getString("CajaID"));
					reversasOperBean.setSucursalID(resultSet.getString("SucursalID"));
					reversasOperBean.setFecha(resultSet.getString("Fecha"));  
					reversasOperBean.setUsuarioAutID(resultSet.getString("UsuarioID"));
					
					reversasOperBean.setClaveUsuarioAut(resultSet.getString("ClaveUsuarioAut"));
					reversasOperBean.setContraseniaAut(resultSet.getString("ContraseniaAut"));
					
					return reversasOperBean;
				}
			});
			consultaBean= matches.size() > 0 ? (ReversasOperBean) matches.get(0) : null;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Consulta de Transacción de Reversas", e);
		}
		return consultaBean;
		
	}

	

	public ParametrosSesionBean getParametrosSesionBean() {
		return parametrosSesionBean;
	}

	public void setParametrosSesionBean(ParametrosSesionBean parametrosSesionBean) {
		this.parametrosSesionBean = parametrosSesionBean;
	}
	
	
	
}
