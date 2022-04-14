package arrendamiento.dao;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import org.apache.log4j.Logger;
import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.CallableStatementCallback;
import org.springframework.jdbc.core.CallableStatementCreator;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import arrendamiento.bean.SegurosArrendaBean;

import general.bean.ParametrosSesionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

public class SegurosArrendaDAO extends BaseDAO{
	ParametrosSesionBean parametrosSesionBean;
	Logger log = Logger.getLogger( this.getClass() );

	public SegurosArrendaDAO() {
		super();
	}


	/* PARA OBTENER LA CONSULTA PRINCIPAL  */
	public SegurosArrendaBean consultaPrincipal(SegurosArrendaBean segurosArrendaBean, int tipoConsulta) {
		SegurosArrendaBean result = null;
		try{
			// Query con el Store Procedure
			String query = "call ARRASEGURADORACON(" +
					"?,?,?,?,?, ?,?,?,?);";
			Object[] parametros = { 
					Utileria.convierteLong(segurosArrendaBean.getSeguroArrendaID()), 
					tipoConsulta,
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA, 
					
					Constantes.STRING_VACIO,
					"ArrendamientosDAO.consultaPrincipal",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO 
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call ARRASEGURADORACON( " + Arrays.toString(parametros) + ")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum)throws SQLException {
					SegurosArrendaBean arrendaBean = new SegurosArrendaBean();
					arrendaBean.setSeguroArrendaID(resultSet.getString("AseguradoraID"));              
					arrendaBean.setDescripcion(resultSet.getString("Descripcion"));             
				    return arrendaBean;
				}
			});
			result =  matches.size() > 0 ? (SegurosArrendaBean) matches.get(0) : null;
		}catch(Exception e ){
			e.printStackTrace();
		}
		return result;
	}
	
	/* lista principal de creditos de fondeo*/
	public List listaPrincipal(final SegurosArrendaBean segurosArrendaBean, final int tipoLista){
		transaccionDAO.generaNumeroTransaccion();
		List matches =new  ArrayList();
		final List matches2 =new  ArrayList();
		matches =(List) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new CallableStatementCreator() {
			public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
				String query = "call ARRASEGURADORALIS(" +
						"?,?,?,?,?, ?,?,?,?);";
				CallableStatement sentenciaStore = arg0.prepareCall(query);
				sentenciaStore.setString("Par_Descripcion",segurosArrendaBean.getSeguroArrendaID());
				sentenciaStore.setInt("Par_NumLis",tipoLista);
				sentenciaStore.setInt("Aud_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
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
						SegurosArrendaBean	respuesta	= new SegurosArrendaBean();
						respuesta.setSeguroArrendaID(resultadosStore.getString("AseguradoraID"));              
						respuesta.setDescripcion(resultadosStore.getString("Descripcion"));    
						matches2.add(respuesta);
					}	 
				}
				return matches2;
			}
		});
		return matches;
	}
}
