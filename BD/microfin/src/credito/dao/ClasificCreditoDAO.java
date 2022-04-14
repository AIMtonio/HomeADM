package credito.dao;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;

import general.dao.BaseDAO;
import herramientas.Constantes;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;

import org.springframework.jdbc.core.RowMapper;
import credito.bean.ClasificCreditoBean;
 
public class ClasificCreditoDAO extends BaseDAO  {
	public ClasificCreditoDAO() {
		super();
	}
	
	/* Consuta de clasificacion de Creditos por Llave Foranea*/
	public ClasificCreditoBean consultaForanea(ClasificCreditoBean clasificCredito, int tipoConsulta) {
		//Query con el Store Procedure
		String query = "call CLASIFICCREDITOCON(?,?,?,?,?,?,?,?,?);";
		
				Object[] parametros = {	clasificCredito.getClasificacionID(),	
										tipoConsulta,
										Constantes.ENTERO_CERO,
										Constantes.ENTERO_CERO,
										Constantes.FECHA_VACIA,
										Constantes.STRING_VACIO,
										"ClasificCreditoDAO.consultaForanea",
										Constantes.ENTERO_CERO,
										Constantes.ENTERO_CERO};
				loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CLASIFICCREDITOCON(" +Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				ClasificCreditoBean clasificCredito = new ClasificCreditoBean();
				clasificCredito.setClasificacionID(String.valueOf(resultSet.getInt(1)));	
				clasificCredito.setDescripClasifica(resultSet.getString(2));
					return clasificCredito;
	
			}
		});
				
		return matches.size() > 0 ? (ClasificCreditoBean) matches.get(0) : null;
	}
	
	
	
	public List listaClasificCredito(final ClasificCreditoBean clasificCredito, 
			int tipoLista){
		String query = "call CLASIFICCREDITOLIS(?,?, ?,?,?,?,?,?,?)";
		Object parametros [] ={
				
				clasificCredito.getDescripClasifica(),
				tipoLista,
				
				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				"ClasificCreditoDAO.listaClasificCredito",
				parametrosAuditoriaBean.getSucursal(),
				parametrosAuditoriaBean.getNumeroTransaccion()
				
		};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CLASIFICCREDITOLIS(" +Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				ClasificCreditoBean clasificCredito = new ClasificCreditoBean();
				clasificCredito.setClasificacionID(String.valueOf(resultSet.getInt(1))); 
				clasificCredito.setDescripClasifica((resultSet.getString(2)));
				return clasificCredito;
			}
		});
		return matches;				
	}

	
	public List listaCombo(final ClasificCreditoBean clasificCredito, 
			int tipoLista){
		String query = "call CLASIFICCREDITOLIS(?,?, ?,?,?,?,?,?,?)";		
		Object parametros [] ={
				
				clasificCredito.getDescripClasifica(),
				tipoLista,
				
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"ClasificCreditoDAO.listaCombo",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO				
		};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CLASIFICCREDITOLIS(" +Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				ClasificCreditoBean clasificCredito = new ClasificCreditoBean();
				clasificCredito.setClasificacionID(String.valueOf(resultSet.getInt(1))); 
				clasificCredito.setDescripClasifica((resultSet.getString(2)));
				
				
				return clasificCredito;
			}
		});
		return matches;				
	}

}
