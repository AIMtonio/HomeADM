package regulatorios.dao;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import org.springframework.jdbc.core.RowMapper;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;

import regulatorios.bean.OpcionesMenuRegBean;
import regulatorios.bean.RegulatorioD0842Bean;
import tesoreria.bean.DispersionBean;
import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

public class OpcionesMenuRegDAO extends BaseDAO {
	public OpcionesMenuRegDAO() {
		super();
	}
	

	
	//Lista de Opciones del menú para Combo Box	
	public List lista(OpcionesMenuRegBean opcionesMenuReg, int tipoLista) {
		//Query con el Store Procedure
		String query = "call OPCIONESMENUREGLIS(?,?,?,?,? ,?,?,?,?,?);";
		Object[] parametros = { 
								opcionesMenuReg.getMenuID(),
								opcionesMenuReg.getDescripcion(),
								tipoLista,			
								
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"opcionesMenuReg.consultaPrincipal",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO
								};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call OPCIONESMENUREGLIS(" + Arrays.toString(parametros) +")");
		
	List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				OpcionesMenuRegBean opcionesMenuReg = new OpcionesMenuRegBean();
				opcionesMenuReg.setOpcionMenuID(resultSet.getString("OpcionMenuID"));
				opcionesMenuReg.setDescripcion(resultSet.getString("Descripcion"));
				opcionesMenuReg.setCodigoOpcion(resultSet.getString("CodigoOpcion"));
				
				return opcionesMenuReg;				
			}
		});
				
		return matches;
	}
	
	public OpcionesMenuRegBean consulta(OpcionesMenuRegBean opcionesMenuReg, int tipoLista) {
		//Query con el Store Procedure
		String query = "call OPCIONESMENUREGLIS(?,?,?,?,? ,?,?,?,?,?);";
		Object[] parametros = { 
								opcionesMenuReg.getMenuID(),
								opcionesMenuReg.getCodigoOpcion(),
								tipoLista,			
								
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"opcionesMenuReg.consultaPrincipal",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO
								};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call OPCIONESMENUREGLIS(" + Arrays.toString(parametros) +")");
		
	List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				OpcionesMenuRegBean opcionesMenuReg = new OpcionesMenuRegBean();
				opcionesMenuReg.setOpcionMenuID(resultSet.getString("OpcionMenuID"));
				opcionesMenuReg.setDescripcion(resultSet.getString("Descripcion"));
				opcionesMenuReg.setCodigoOpcion(resultSet.getString("CodigoOpcion"));
				
				return opcionesMenuReg;
					
			}
		});
		return matches.size() > 0 ? (OpcionesMenuRegBean) matches.get(0) : null;			
	}
	
	
	public OpcionesMenuRegBean consultaTasa(OpcionesMenuRegBean opcionesMenuReg, int tipoLista) {
		//Query con el Store Procedure
		String query = "call CATTASAREFEREGCON(?,?,?,?,? ,?,?,?,?);";
		Object[] parametros = { 
								opcionesMenuReg.getCodigoOpcion(),
								tipoLista,			
								
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"opcionesMenuReg.consultaPrincipal",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO
								};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CATTASAREFEREGCON(" + Arrays.toString(parametros) +")");
		
	List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				OpcionesMenuRegBean opcionesMenuReg = new OpcionesMenuRegBean();
				opcionesMenuReg.setCodigoOpcion(resultSet.getString("CodigoOpcion"));
				opcionesMenuReg.setDescripcion(resultSet.getString("Descripcion"));
				
				return opcionesMenuReg;
					
			}
		});
		return matches.size() > 0 ? (OpcionesMenuRegBean) matches.get(0) : null;			
	}
	
	/* combo */
	//Lista de Opciones del menú para Combo Box	
	public List listaClasificacConta(OpcionesMenuRegBean opcionesMenuReg, int tipoLista) {
		//Query con el Store Procedure
		List matches;
		String query = "call CLASIFICACONTAREGLIS(?,?,?, ?,?,?, ?,?,?);";
	try{
			Object[] parametros = { 
					opcionesMenuReg.getPlazo(),
					tipoLista,			
					
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					"ClasificaConta.consultaPrincipal",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO
					};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CLASIFICACONTAREGLIS(" + Arrays.toString(parametros) +")");
			
			 matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
			OpcionesMenuRegBean opcionesMenuReg = new OpcionesMenuRegBean();
			opcionesMenuReg.setCodigoOpcion(resultSet.getString("CodigoOpcion"));
			opcionesMenuReg.setDescripcion(resultSet.getString("Descripcion"));
			
			return opcionesMenuReg;				
			}
		});
		
	}catch(Exception e){
		matches = new ArrayList();		
		e.printStackTrace();
	}
		
		return matches;
	}
	
	public List listaTipotasa(OpcionesMenuRegBean opcionesMenuReg, int tipoLista) {
		//Query con el Store Procedure
		List matches;
		String query = "call CATTIPOTASAREGLIS(?,?,?, ?,?,?, ?,?);";
	try{
			Object[] parametros = { 
					tipoLista,			
					
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					"listaTipotasa.consultaPrincipal",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO
					};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CATTIPOTASAREGLIS(" + Arrays.toString(parametros) +")");
			
			 matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
			OpcionesMenuRegBean opcionesMenuReg = new OpcionesMenuRegBean();
			opcionesMenuReg.setCodigoOpcion(resultSet.getString("CodigoOpcion"));
			opcionesMenuReg.setDescripcion(resultSet.getString("Descripcion"));
			
			return opcionesMenuReg;				
			}
		});
		
	}catch(Exception e){
		matches = new ArrayList();		
		e.printStackTrace();
	}
		
		return matches;
	}
	
	
	public List listaTasaRefe(OpcionesMenuRegBean opcionesMenuReg, int tipoLista) {
		//Query con el Store Procedure
		List matches;
		String query = "call CATTASAREFEREGLIS(?,?,?, ?,?,?,?, ?,?);";
	try{
			Object[] parametros = { 
					opcionesMenuReg.getDescripcion(),
					tipoLista,			
					
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					"listaTasaRefe.consultaPrincipal",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO
					};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CATTASAREFEREGLIS(" + Arrays.toString(parametros) +")");
			
			 matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
			OpcionesMenuRegBean opcionesMenuReg = new OpcionesMenuRegBean();
			opcionesMenuReg.setCodigoOpcion(resultSet.getString("CodigoOpcion"));
			opcionesMenuReg.setDescripcion(resultSet.getString("Descripcion"));
			
			return opcionesMenuReg;				
			}
		});
		
	}catch(Exception e){
		matches = new ArrayList();		
		e.printStackTrace();
	}
		
		return matches;
	}
	
	
	public List listaOpeDifTasa(OpcionesMenuRegBean opcionesMenuReg, int tipoLista) {
		//Query con el Store Procedure
		List matches;
		String query = "call CATOPEDIFTASAREFLIS(?,?,?, ?,?,?, ?,?);";
	try{
			Object[] parametros = { 
					tipoLista,			
					
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					"listaOpeDifTasa.consultaPrincipal",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO
					};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CATOPEDIFTASAREFLIS(" + Arrays.toString(parametros) +")");
			
			 matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
			OpcionesMenuRegBean opcionesMenuReg = new OpcionesMenuRegBean();
			opcionesMenuReg.setCodigoOpcion(resultSet.getString("CodigoOpcion"));
			opcionesMenuReg.setDescripcion(resultSet.getString("Descripcion"));
			
			return opcionesMenuReg;				
			}
		});
		
	}catch(Exception e){
		matches = new ArrayList();		
		e.printStackTrace();
	}
		
		return matches;
	}
	
	public List listaTipodispCred(OpcionesMenuRegBean opcionesMenuReg, int tipoLista) {
		//Query con el Store Procedure
		List matches;
		String query = "call CATTIPODISCREDREGLIS(?,?,?, ?,?,?, ?,?);";
	try{
			Object[] parametros = { 
					tipoLista,			
					
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					"listaTipodispCred.consultaPrincipal",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO
					};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CATTIPODISCREDREGLIS(" + Arrays.toString(parametros) +")");
			
			 matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
			OpcionesMenuRegBean opcionesMenuReg = new OpcionesMenuRegBean();
			opcionesMenuReg.setCodigoOpcion(resultSet.getString("CodigoOpcion"));
			opcionesMenuReg.setDescripcion(resultSet.getString("Descripcion"));
			
			return opcionesMenuReg;				
			}
		});
		
	}catch(Exception e){
		matches = new ArrayList();		
		e.printStackTrace();
	}
		
		return matches;
	}
	
	public List listaPeriodoPago(OpcionesMenuRegBean opcionesMenuReg, int tipoLista) {
		//Query con el Store Procedure
		List matches;
		String query = "call CATPERIODOPAGCREGLIS(?,?,?, ?,?,?, ?,?);";
	try{
			Object[] parametros = { 
					tipoLista,			
					
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					"listaPeriodoPago.consultaPrincipal",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO
					};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CATPERIODOPAGCREGLIS(" + Arrays.toString(parametros) +")");
			
			 matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
			OpcionesMenuRegBean opcionesMenuReg = new OpcionesMenuRegBean();
			opcionesMenuReg.setCodigoOpcion(resultSet.getString("CodigoOpcion"));
			opcionesMenuReg.setDescripcion(resultSet.getString("Descripcion"));
			
			return opcionesMenuReg;				
			}
		});
		
	}catch(Exception e){
		matches = new ArrayList();		
		e.printStackTrace();
	}
		
		return matches;
	}
	
	//tipos de garantias
	public List listaTipoGarantia(OpcionesMenuRegBean opcionesMenuReg, int tipoLista) {
		//Query con el Store Procedure
		List matches;
		String query = "call CATTIPOGARANREGLIS(?,?,?, ?,?,?, ?,?);";
	try{
			Object[] parametros = { 
					tipoLista,			
					
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					"listaPeriodoPago.consultaPrincipal",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO
					};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CATTIPOGARANREGLIS(" + Arrays.toString(parametros) +")");
			
			 matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
			OpcionesMenuRegBean opcionesMenuReg = new OpcionesMenuRegBean();
			opcionesMenuReg.setCodigoOpcion(resultSet.getString("CodigoOpcion"));
			opcionesMenuReg.setDescripcion(resultSet.getString("Descripcion"));
			
			return opcionesMenuReg;				
			}
		});
		
	}catch(Exception e){
		matches = new ArrayList();		
		e.printStackTrace();
	}
		
		return matches;
	}


	public List listaTipoCargo(OpcionesMenuRegBean opcionesMenuRegBean,
			int tipoLista) {
		//Query con el Store Procedure
				List matches;
				String query = "call CATCARGOSOCIEDADLIS(?,?,?,?, ?,?,?, ?,?);";
			try{
					Object[] parametros = { 
							opcionesMenuRegBean.getTipoInstitID(),
							tipoLista,			
							
							Constantes.ENTERO_CERO,
							Constantes.ENTERO_CERO,
							Constantes.FECHA_VACIA,
							Constantes.STRING_VACIO,
							"listaTipoCargo.consultaPrincipal",
							Constantes.ENTERO_CERO,
							Constantes.ENTERO_CERO
							};
					loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CATCARGOSOCIEDADLIS(" + Arrays.toString(parametros) +")");
					
					 matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
					public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					OpcionesMenuRegBean opcionesMenuReg = new OpcionesMenuRegBean();
					opcionesMenuReg.setCodigoOpcion(resultSet.getString("CargoID"));
					opcionesMenuReg.setDescripcion(resultSet.getString("Descripcion"));
					
					return opcionesMenuReg;				
					}
				});
				
			}catch(Exception e){
				matches = new ArrayList();		
				e.printStackTrace();
			}
				
				return matches;
	}



	public List listaCausaBaja(OpcionesMenuRegBean opcionesMenuRegBean,
			int tipoLista) {
		//Query con el Store Procedure
		List matches;
		String query = "call CATCAUSABAJALIS(?,?,?, ?,?,?, ?,?);";
		try{
				Object[] parametros = { 
						tipoLista,			
						
						Constantes.ENTERO_CERO,
						Constantes.ENTERO_CERO,
						Constantes.FECHA_VACIA,
						Constantes.STRING_VACIO,
						"listaCausaBaja.consultaPrincipal",
						Constantes.ENTERO_CERO,
						Constantes.ENTERO_CERO
						};
				loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CATCAUSABAJALIS(" + Arrays.toString(parametros) +")");
				
				 matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				OpcionesMenuRegBean opcionesMenuReg = new OpcionesMenuRegBean();
				opcionesMenuReg.setCodigoOpcion(resultSet.getString("CausaBajaID"));
				opcionesMenuReg.setDescripcion(resultSet.getString("Descripcion"));
				
				return opcionesMenuReg;				
				}
			});
			
		}catch(Exception e){
			matches = new ArrayList();		
			e.printStackTrace();
		}
		
		return matches;
	}

	
	public List listaTipoOrgano(OpcionesMenuRegBean opcionesMenuRegBean,
			int tipoLista) {
		//Query con el Store Procedure
				List matches;
				String query = "call CATORGANOLIS(?,?,?,?, ?,?,?, ?,?);";
			try{
					Object[] parametros = { 
							opcionesMenuRegBean.getTipoInstitID(),
							tipoLista,			
							
							Constantes.ENTERO_CERO,
							Constantes.ENTERO_CERO,
							Constantes.FECHA_VACIA,
							Constantes.STRING_VACIO,
							"listaTipoOrgano",
							Constantes.ENTERO_CERO,
							Constantes.ENTERO_CERO
							};
					loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CATORGANOLIS(" + Arrays.toString(parametros) +")");
					
					 matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
					public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					OpcionesMenuRegBean opcionesMenuReg = new OpcionesMenuRegBean();
					opcionesMenuReg.setCodigoOpcion(resultSet.getString("OrganoID"));
					opcionesMenuReg.setDescripcion(resultSet.getString("Descripcion"));
					
					return opcionesMenuReg;				
					}
				});

				
			}catch(Exception e){
				matches = new ArrayList();		
				e.printStackTrace();
			}
				
				return matches;
	}
	
	
	
	public List listaNivelIdentidad(OpcionesMenuRegBean opcionesMenuReg, int tipoLista) {
		//Query con el Store Procedure
		List matches;
		String query = "call CATNIVELENTIDADREGGLIS(?,?,?, ?,?,?, ?,?);";
	try{
			Object[] parametros = { 
					tipoLista,			
					
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					"listaPeriodoPago.consultaPrincipal",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO
					};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CATNIVELENTIDADREGGLIS(" + Arrays.toString(parametros) +")");
			
			 matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
			OpcionesMenuRegBean opcionesMenuReg = new OpcionesMenuRegBean();
			opcionesMenuReg.setCodigoOpcion(resultSet.getString("CodigoOpcion"));
			opcionesMenuReg.setDescripcion(resultSet.getString("Desplegado"));
			
			return opcionesMenuReg;				
			}
		});
		
	}catch(Exception e){
		matches = new ArrayList();		
		e.printStackTrace();
	}
		
		return matches;
	}
		
				
	
	
	public List listaClasContaC0922(OpcionesMenuRegBean opcionesMenuReg, int tipoLista) {
		//Query con el Store Procedure
		List matches;
		String query = "call CATCLASCONTAC0922LIS(?,?,?, ?,?,?, ?,?);";
	try{
			Object[] parametros = { 
					tipoLista,			
					
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					"listaClasContaC0922.consultaPrincipal",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO
					};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CATCLASCONTAC0922LIS(" + Arrays.toString(parametros) +")");
			
			 matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
			OpcionesMenuRegBean opcionesMenuReg = new OpcionesMenuRegBean();
			opcionesMenuReg.setCodigoOpcion(resultSet.getString("ClasContableID"));
			opcionesMenuReg.setDescripcion(resultSet.getString("Descripcion"));
			
			return opcionesMenuReg;				
			}
		});
		
	}catch(Exception e){
		matches = new ArrayList();		
		e.printStackTrace();
	}
		
		return matches;
	}
	
	public List listaTipoPercepcion(OpcionesMenuRegBean opcionesMenuReg, int tipoLista) {
		//Query con el Store Procedure
		List matches;
		String query = "call CATTIPOPERCEPCIONLIS(?,?,?, ?,?,?, ?,?);";
	try{
			Object[] parametros = { 
					tipoLista,			
					
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					"listaTipoPercepcion.consultaPrincipal",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO
					};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CATTIPOPERCEPCIONLIS(" + Arrays.toString(parametros) +")");
			
			 matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
			OpcionesMenuRegBean opcionesMenuReg = new OpcionesMenuRegBean();
			opcionesMenuReg.setCodigoOpcion(resultSet.getString("TipoPercepcionID"));
			opcionesMenuReg.setDescripcion(resultSet.getString("Descripcion"));
			
			return opcionesMenuReg;				
			}
		});
		
	}catch(Exception e){
		matches = new ArrayList();		
		e.printStackTrace();
	}
		
		return matches;
	}
			
}