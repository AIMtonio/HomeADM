package ventanilla.dao;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;
import org.springframework.jdbc.core.RowMapper;
import ventanilla.bean.DenominacionMovsBean;
import ventanilla.dao.CajasTransferDAO;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;
 
public class DenominacionMovsDAO extends BaseDAO{
	public DenominacionMovsDAO(){
		super();
	}	
	public DenominacionMovsBean consultaPrincipal(DenominacionMovsBean denominacionMovsBean, int tipoConsulta){
		
		String query = "call DENOMOVSCON(?,?,?,?,?,  ?,?,?,?,?,	?,?,?);";
		Object[] parametros = { 
				Utileria.convierteEntero(denominacionMovsBean.getCajaID()) ,
				Utileria.convierteEntero(denominacionMovsBean.getSucursalID()),
				denominacionMovsBean.getFecha(),
				Utileria.convierteEntero(denominacionMovsBean.getMonedaID()),
				Utileria.convierteEntero(denominacionMovsBean.getDenominacionID()),
				
				tipoConsulta,
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				
				"CajasVentanillaDAO.consultaPrincipal",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO 
			};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call DENOMOVSCON(" + Arrays.toString(parametros)  +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				DenominacionMovsBean denominacionMovs = new DenominacionMovsBean();
				denominacionMovs.setCajaID(resultSet.getString("CajaID"));
				denominacionMovs.setCantidad(resultSet.getString("Cantidad"));
				denominacionMovs.setDenominacionID(resultSet.getString("DenominacionID"));
				denominacionMovs.setFecha(resultSet.getString("Fecha"));
				denominacionMovs.setMonedaID(resultSet.getString("MonedaID"));
				denominacionMovs.setMonto(resultSet.getString("Monto"));
				denominacionMovs.setNaturaleza(resultSet.getString("Naturaleza"));
				denominacionMovs.setSucursalID(resultSet.getString("SucursalID"));
				denominacionMovs.setTransaccion(resultSet.getString("Transaccion"));
				return denominacionMovs;
			}
		});
		return matches.size() > 0 ? (DenominacionMovsBean) matches.get(0) : null;
		
	}
	public DenominacionMovsBean consultaFecha(DenominacionMovsBean denominacionMovsBean, int tipoConsulta){
		DenominacionMovsBean beanConsulta = null;
		try{
			String query = "call DENOMOVSCON(?,?,?,?,?,  ?,?,?,?,?,	?,?,?);";
			Object[] parametros = { 
					Utileria.convierteEntero(denominacionMovsBean.getCajaID()) ,
					Utileria.convierteEntero(denominacionMovsBean.getSucursalID()),
					denominacionMovsBean.getFecha(),
					Utileria.convierteEntero(denominacionMovsBean.getMonedaID()),
					Constantes.ENTERO_CERO,
					tipoConsulta,
					
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					"CajasVentanillaDAO.consultaPrincipal",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO 
				};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call DENOMOVSCON(" + Arrays.toString(parametros)  +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					DenominacionMovsBean denominacionMovs = new DenominacionMovsBean();
					denominacionMovs.setFecha(resultSet.getString(1));
					System.out.println("resultSet.getString(1)"+resultSet.getString(1));
					return denominacionMovs;
				}
			});
			beanConsulta =  matches.size() > 0 ? (DenominacionMovsBean) matches.get(0) : null;
		}catch(Exception e){
			e.printStackTrace();
		}
		return beanConsulta;
	}
	
}
