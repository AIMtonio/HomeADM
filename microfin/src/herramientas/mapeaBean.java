package herramientas;

import java.beans.IntrospectionException;
import java.beans.Introspector;
import java.beans.PropertyDescriptor;
import java.lang.reflect.Field;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.sql.Blob;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.Set;

import general.bean.BaseBean;
import general.bean.BaseBeanResponseWS;
import general.bean.MensajeTransaccionBean;

/**
 * @Autor: mreyes
 * @Fecha: 15/06/2015
 * @DescripcionGeneral: Clase echa para mapear los valores de un bean, Lista u/o Arrays
 * @DescripcionDetallada:
*/
public class mapeaBean {
	
	private static boolean mostrarMensajesErrorGenericos;
	
	public static interface FORMATO {
        String DD_MM_AAAA_Diag 				= "dd/MM/yyyy";
        String DD_MMM_AAAA_Diag 			= "dd/MMM/yyyy";
        String DD_MM_AAAA_Guion 			= "dd-MM-yyyy";
        String DD_MM_AAAA_Guion_Minutos 	= "dd-MM-yyyy HH:mm:ss";
        String AAAA__MM_DD_Guion_Minutos 	= "yyyy-MM-dd HH:mm:ss";
        String AAAA__DD_MM_Guion_Minutos 	= "yyyy-dd-MM HH:mm:ss";
        String DD_MMM_AAAA_Guion 			= "dd-MMM-yyyy";
        String DD_MMMM_AAAA      			= "dd 'de' MMMMM 'del' yyyy";
        String DD_MMMM_AAAACorto 			= "dd 'de' MMMMM 'del' yyyy";
        String HHmm 						= "HH:mm";
        String HHmmss 						= "HH:mm:ss";
        String HHmmssSS 					= "HH:mm:ss:SS";
        String AAAA_MM_DD_Guion 			= "yyyy-MM-dd";
        String AAAA_MMM_DD_Guion			= "yyyy-MMM-dd";
        String AAAA_MM_DD_Diag 				= "yyyy/MM/dd";
        String AAAA_MMM_DD_Diag 			= "yyyy/MMM/dd";
        String AAAA_MM_DD_SinGuion 			= "yyyyMMdd";
        String AAAA_MM_DD_SinGuionMinunos 	= "yyyyMMdd HH:mm:ss";
        String AAAA_MM_DD_Diag_Minutos 		= "yyyy/MM/dd HH:mm:ss";
    }
	
	public static List<String>  datosEnmascarar= new ArrayList<String>();
    /**
    * @Autor: mreyes
    * @param: int numeroTabs 
    * @Fecha: 15/06/2015
    * @DescripcionGeneral: devuelve numero de tabs
    * @DescripcionDetallada:
    */
    private static String getTab(int numeroTabs){
        String resultado="";
        for(int i=0;i<numeroTabs;i++)
            resultado+="\t"+"|__";
        return resultado;
    }
    
    /**
    * @Autor: mreyes
    * @param: Object atributo 
    * @return Boolean
    * @Fecha: 15/06/2015
    * @DescripcionGeneral: determina si el parametro de entrada es una lista
    * @DescripcionDetallada:
    */
    public static Boolean esLista(Object atributo){
        Boolean resultado=false;
        if(atributo==null){
            return resultado;
        }
        String tipoDato=atributo.getClass().getSimpleName();
        if(tipoDato.equals("List") ||
            tipoDato.equals("ArrayList")){
            resultado= true;
        }else
            if(tipoDato.equals("Field")){
                Field field =(Field)atributo;
                if(field.getType().getSimpleName().equals("List")||
                    field.getType().getSimpleName().equals("ArrayList"))
                    resultado= true;
                else{
                    resultado= false;
                }
            }
            return resultado;
    }
    
    /**
    * @Autor: mreyes
    * @param: Object atributo 
    * @return Boolean
    * @Fecha: 15/06/2015
    * @DescripcionGeneral: determina si el parametro de entrada es un String
    * @DescripcionDetallada:
    */
    public static Boolean esString(Object atributo){
        Boolean resultado=false;
        if(atributo==null){
            return resultado;
        }
        String tipoDato=atributo.getClass().getSimpleName();
        if(tipoDato.equals("String")){
            resultado= true;
        }else
            if(tipoDato.equals("Field")){
                Field field =(Field)atributo;
                if(field.getType().getSimpleName().equals("String"))
                    resultado= true;
                else{
                    resultado= false;
                }
            }
        return resultado;
    }
    
    
    
    /**
    * @Autor: mreyes
    * @param: Object atributo 
    * @return Boolean
    * @Fecha: 15/06/2015
    * @DescripcionGeneral: determina si el parametro de entrada es un Entero
    * @DescripcionDetallada:
    */
    public static Boolean esEntero(Object atributo){
        Boolean resultado=false;
        if(atributo==null){
            return resultado;
        }
        String tipoDato=atributo.getClass().getSimpleName();
        if(tipoDato.equals("int")||
            tipoDato.equals("Integer")){
            resultado= true;
        }else
            if(tipoDato.equals("Field")){
                Field field =(Field)atributo;
                if(field.getType().getSimpleName().equals("Integer") ||
                    field.getType().getSimpleName().equals("int"))
                    resultado= true;
                else{
                    resultado= false;
                }
            }
            return resultado;
    }
    
    /**
     * @Autor: mreyes
     * @param: Object atributo 
     * @return Boolean
     * @Fecha: 15/06/2015
     * @DescripcionGeneral: determina si el parametro de entrada es un Long
     * @DescripcionDetallada:
     */
     public static Boolean esLong(Object atributo){
         Boolean resultado=false;
         if(atributo==null){
             return resultado;
         }
         
         String tipoDato=atributo.getClass().getSimpleName();
         if(tipoDato.equals("long")||
             tipoDato.equals("Long")){
             resultado= true;
         }else
             if(tipoDato.equals("Field")){
                 Field field =(Field)atributo;
                 if(field.getType().getSimpleName().equals("Long") ||
                     field.getType().getSimpleName().equals("long"))
                     resultado= true;
                 else{
                     resultado= false;
                 }
             }
             return resultado;
     }
    
    /**
    * @Autor: mreyes
    * @param: Object atributo 
    * @return Boolean
    * @Fecha: 15/06/2015
    * @DescripcionGeneral: determina si el parametro de entrada es un Booleano
    * @DescripcionDetallada:
    */
    public static Boolean esBooleano(Object atributo){
        Boolean resultado=false;
        if(atributo==null){
            return resultado;
        }
        String tipoDato=atributo.getClass().getSimpleName();
        if(tipoDato.equals("Boolean")||
            tipoDato.equals("boolean")){
            resultado= true;
        }else
            if(tipoDato.equals("Field")){
                Field field =(Field)atributo;
                if(field.getType().getSimpleName().equals("Boolean") ||
                    field.getType().getSimpleName().equals("boolean"))
                    resultado= true;
                else{
                    resultado= false;
                }
            }
            return resultado;
    }
    
    
    /**
    * @Autor: mreyes
    * @param: Object atributo 
    * @return Boolean
    * @Fecha: 15/06/2015
    * @DescripcionGeneral: determina si el parametro de entrada es un Double
    * @DescripcionDetallada:
    */
    public static Boolean esDouble(Object atributo){
        Boolean resultado=false;
        if(atributo==null){
            return resultado;
        }
        String tipoDato=atributo.getClass().getSimpleName();
        if(tipoDato.equals("Double")){
            resultado= true;
        }else
            if(tipoDato.equals("Field")){
                Field field =(Field)atributo;
                if(field.getType().getSimpleName().equals("Double") ||
                    field.getType().getSimpleName().equals("double"))
                    resultado= true;
                else{
                    resultado= false;
                }
            }
            return resultado;
    }
    
    
    /**
    * @Autor: mreyes
    * @param: Object atributo 
    * @return Boolean
    * @Fecha: 15/06/2015
    * @DescripcionGeneral: determina si el parametro de entrada es un Date
    * @DescripcionDetallada:
    */
    public static Boolean esFecha(Object atributo){
        Boolean resultado=false;        
        if(atributo==null){
            return resultado;
        }
        String tipoDato=atributo.getClass().getSimpleName();  
        if(tipoDato.equals("Date")){
            resultado= true;
        }else
            if(tipoDato.equals("Field")){
                Field field =(Field)atributo;
                if(field.getType().getSimpleName().equals("Date") ||
                   field.getType().getSimpleName().equals("Date")){
                    resultado= true;          
                }else{
                    resultado= false;
                }
            }
            return resultado;
    }
    
    
    /**
    * @Autor: mreyes
    * @param: Object atributo 
    * @return Boolean
    * @Fecha: 15/06/2015
    * @DescripcionGeneral: determina si el parametro de entrada es un Arreglo
    * @DescripcionDetallada:
    */
    public static Boolean esArreglo(Object atributo){
        Boolean resultado=false;
        if(atributo==null){
            return resultado;
        }
        Class clase=atributo.getClass();        
        String tipoDato=atributo.getClass().getSimpleName();
        if(clase.isArray()){
            resultado= true;
        }else
            if(tipoDato.equals("Field")){
                Field field =(Field)atributo;
                if(field.getType().isArray())
                    resultado= true;
                else{
                    resultado= false;
                }
            }
            return resultado;
    }
    
    /**
     * @Autor: jperez
     * @param: Object atributo 
     * @return Boolean
     * @Fecha: 07/08/2018
     * @DescripcionGeneral: Determina si el parametro de entrada es un Map
     * @DescripcionDetallada:
     */
     public static Boolean esMap(Object atributo){
         Boolean resultado=false;
         if(atributo==null){
             return resultado;
         }
         Class clase=atributo.getClass();
         String tipoDato=atributo.getClass().getSimpleName();
         
         if(Map.class.isAssignableFrom(clase)){
             resultado= true;
         }
         else if(tipoDato.equals("Field")){
             Field field =(Field)atributo;
             if(Map.class.isAssignableFrom(field.getType())) {
            	 resultado= true;
             }                 
             else{
                 resultado= false;
             }
         }
         
         return resultado;
     }
     
     /**
      * @Autor: jperez
      * @param: Object atributo 
      * @return Boolean
      * @Fecha: 07/08/2018
      * @DescripcionGeneral: Determina si el parametro es un bean de Cardinal
      * @DescripcionDetallada:
      */
      public static Boolean esCardinalBean(Object atributo){
          Boolean resultado=false;
          if(atributo==null){
              return resultado;
          }
          
          if(atributo instanceof BaseBean || atributo instanceof BaseBeanResponseWS || atributo instanceof MensajeTransaccionBean ) {
        	  resultado = true;
          }
          
          return resultado;
      }
    
    /**
     * @Autor: jperez
     * @param: Object atributo 
     * @return Blob
     * @Fecha: 07/08/2018
     * @DescripcionGeneral: determina si el parametro de entrada es un String
     * @DescripcionDetallada:
     */
     public static Boolean esBlob(Object atributo){
         Boolean resultado=false;
         if(atributo==null){
             return resultado;
         }
         String tipoDato=atributo.getClass().getSimpleName();
         if(tipoDato.equals("Blob")){
             resultado= true;
         }else{
             if(tipoDato.equals("Field")){
                 Field field =(Field)atributo;
                 if(field.getType().getSimpleName().equals("Blob"))
                     resultado= true;
                 else{
                     resultado= false;
                 }
             }
         }
         return resultado;
     }
   
   
    /**
    * @Autor: mreyes
    * @param: Object bean, String atributo
    * @return Method
    * @Fecha: 15/06/2015
    * @DescripcionGeneral: obtiene el metodo Getter de un atributo especificado, si no encuentra el metodo retorna null
    * @DescripcionDetallada: como parametros de entrada recibe la instancia de un objeto, y el nombre del atributo al que se desea conocer su meto
    *                         metodo getter
    */
    public static Method getGetterName(Object bean,String atributo){      
       Method respuesta=null;
       try{
           // obtenemos todas los atributos de la clase y los recorremos obteniendo su metodo getter
           for(PropertyDescriptor propertyDescriptor : 
               Introspector.getBeanInfo(bean.getClass()).getPropertyDescriptors()){
               //Method metodoGetterBean=propertyDescriptor.getReadMethod();
               // propertyEditor.getReadMethod() exposes the getter
               // btw, this may be null if you have a write-only property
               if(propertyDescriptor.getName().equals(atributo)){
                   return propertyDescriptor.getReadMethod();                  
               }else{
                   respuesta=null;
                   //System.out.println(propertyDescriptor.getName());
              }
           }
           
       }catch(IntrospectionException e){
           respuesta=null;
           //System.out.println(e.getMessage());
           //ErrorEjecutarMetodo=true;
       }
       return respuesta;
       
   }
    
    
    /**
    * @Autor: mreyes
    * @param: Object bean, String atributo
    * @return Method
    * @Fecha: 15/06/2015
    * @DescripcionGeneral: obtiene el metodo Setter de un atributo especificado, si no encuentra el metodo retorna null
    * @DescripcionDetallada: como parametros de entrada recibe la instancia de un objeto, y el nombre del atributo al que se desea conocer su meto
    *                         metodo setter
    */
    public static Method getSetterName(Object bean,String atributo){      
       Method respuesta=null;
       try{
           // obtenemos todas los atributos de la clase y los recorremos obteniendo su metodo setter
           for(PropertyDescriptor propertyDescriptor : 
               Introspector.getBeanInfo(bean.getClass()).getPropertyDescriptors()){
               
               if(propertyDescriptor.getName().equals(atributo)){
                   //System.out.println(propertyDescriptor.getWriteMethod());
                   return propertyDescriptor.getWriteMethod();                  
               }else{
                   respuesta=null;
                   //System.out.println(propertyDescriptor.getWriteMethod());
              }
           }
           
       }catch(IntrospectionException e){
           respuesta=null;
           //System.out.println(e.getMessage());
           //ErrorEjecutarMetodo=true;
       }
       
       return respuesta;
       
    }
    
    /**
    * @Autor: mreyes
    * @param: Object bean, Field atributo, int numTabs
    * @return Object[3]
    * @Fecha: 15/06/2015
    * @DescripcionGeneral: retorna un arreglo de 3 pocisiones, en la primera pocision retorna el codigo exito/error
    *                      en la segunda pociion retorna el valor/error en String obtenido del atributo especificado de un objeto(bean)
    *                      en la tercera pocision retorna el valo tal cual, si es un string, retorna un string, si es un array retorna un array etc.
    * @DescripcionDetallada: como parametros de entrada recibe la instancia de un objeto, el atributo al que se desea conocer su valor
    *                        y el numero de identacion(tabs)
    *                        
    *                        Codigos de exito y Error
    *                        Constantes.STR_CODIGOEXITO[0]=codigo Exito(el valor se ha obrenido exitosamente)
    *                        001=getter no encontrado para atributo 
    *                        002=Error: tipo de dato no soportado
    *                        003=Error:getter no es publico
    *                        004=Error al invocar el getter
    */
    public static Object[] getValue(Object bean, Field atributo, int numTabs){
        Object[] respuestaFinal=new Object[3];
        
        Class clase = bean.getClass();    
        
        
        String  valorString="";
        Integer valorEntero;
        Long	valorLong;
        Boolean valorBoleano;
        Double  valorDouble;
        Date    valorDate;
        List    valorLista;
        Object[] valorArreglo;
        Blob 	valorBlob;
        Map 	valorMap;
        
        
        // buscamos el metdo en la clase
        
        Method metodoBean=getGetterName(bean,atributo.getName());
        if(metodoBean==null){
            respuestaFinal[0]="001";
            respuestaFinal[1]="getter no encontrado para atributo "+ atributo.getName();
        }else{
            try{
                // si es un string lo almacenamos en un string
                if(esString(atributo)){
                   //ejecutamos el metodo getter
                   valorString=(String)metodoBean.invoke(bean);
                    if(valorString==null){
                        respuestaFinal[0]=Constantes.STR_CODIGOEXITO[0];
                        respuestaFinal[1]=null;                        
                    }else{
                        respuestaFinal[0]=Constantes.STR_CODIGOEXITO[0];
                        respuestaFinal[1]= valorString ;
                        respuestaFinal[2]=valorString;
                    }
                   return respuestaFinal;
                }
                // si es un entero lo almacenamos en un entero y despues lo convertimos  a string
                if(esEntero(atributo)){
                    //ejecutamos el metodo getter
                   valorEntero=(Integer)metodoBean.invoke(bean);
                    if(valorEntero==null){
                        respuestaFinal[0]=Constantes.STR_CODIGOEXITO[0];
                        respuestaFinal[1]=null;
                    }else{
                        respuestaFinal[0]=Constantes.STR_CODIGOEXITO[0];
                        respuestaFinal[1]=valorEntero.toString();
                        respuestaFinal[2]=valorEntero;
                    }
                   return respuestaFinal;
                }
             // si es un Long lo almacenamos en un Long y despues lo convertimos  a string
                if(esLong(atributo)){
                    //ejecutamos el metodo getter
                   valorLong=(Long)metodoBean.invoke(bean);
                    if(valorLong==null){
                        respuestaFinal[0]=Constantes.STR_CODIGOEXITO[0];
                        respuestaFinal[1]=null;
                    }else{
                        respuestaFinal[0]=Constantes.STR_CODIGOEXITO[0];
                        respuestaFinal[1]=valorLong.toString();
                        respuestaFinal[2]=valorLong;
                    }
                   return respuestaFinal;
                }
                // si es un Booleano lo alamacenamos en un Boolean y despues lo convertimos  a string
                if(esBooleano(atributo)){         
                    //ejecutamos el metodo getter
                    valorBoleano=(Boolean)metodoBean.invoke(bean);
                    if(valorBoleano==null){
                        respuestaFinal[0]=Constantes.STR_CODIGOEXITO[0];
                        respuestaFinal[1]=null;
                    }else{
                        respuestaFinal[0]=Constantes.STR_CODIGOEXITO[0];
                        respuestaFinal[1]=valorBoleano.toString();
                        respuestaFinal[2]=valorBoleano;
                    }
                   return respuestaFinal;
                }
                // si es un Double lo alamacenamos en un Double y despues lo convertimos  a string
                if(esDouble(atributo)){
                    //ejecutamos el metodo getter
                    valorDouble=(Double)metodoBean.invoke(bean);
                    if(valorDouble==null){
                        respuestaFinal[0]=Constantes.STR_CODIGOEXITO[0];
                        respuestaFinal[1]=null;
                    }else{              
                        respuestaFinal[0]=Constantes.STR_CODIGOEXITO[0];
                        respuestaFinal[1]=valorDouble.toString();
                        respuestaFinal[2]=valorDouble;
                    }
                   return respuestaFinal;
                }
                
                // si es un Date lo alamacenamos en un Date y despues lo convertimos  a string
                if(esFecha(atributo)){
                    //ejecutamos el metodo getter
                    valorDate=(Date)metodoBean.invoke(bean);
                    if(valorDate==null){
                        respuestaFinal[0]=Constantes.STR_CODIGOEXITO[0];
                        respuestaFinal[1]=null;
                    }else{ 
                        respuestaFinal[0]=Constantes.STR_CODIGOEXITO[0];
                        respuestaFinal[1]=valorDate.toString();
                        respuestaFinal[2]=valorDate;                       
                    }
                   return respuestaFinal;
                }
                
                // si es una lista 
                if(esLista(atributo)){
                    //ejecutamos el metodo getter
                    valorLista=(List)metodoBean.invoke(bean);
                    if(valorLista==null){
                        respuestaFinal[0]=Constantes.STR_CODIGOEXITO[0];
                        respuestaFinal[1]=null;
                    }else{
                        respuestaFinal[0]=Constantes.STR_CODIGOEXITO[0];
                        respuestaFinal[1]=getBeanValue(valorLista, numTabs+1);
                        respuestaFinal[2]=valorLista;
                    }
                   return respuestaFinal;
                }
                // si es una arreglo 
                if(esArreglo(atributo)){
                    //ejecutamos el metodo getter
                    valorArreglo=(Object[])metodoBean.invoke(bean);
                    if(valorArreglo==null){
                        respuestaFinal[0]=Constantes.STR_CODIGOEXITO[0];
                        respuestaFinal[1]=null;
                    }else{
                        respuestaFinal[0]=Constantes.STR_CODIGOEXITO[0];
                        respuestaFinal[1]=getBeanValue(valorArreglo, numTabs+1);
                        respuestaFinal[2]=valorArreglo;
                    }
                   return respuestaFinal;
                }
                // si es un blob 
                if(esBlob(atributo)){
                    //ejecutamos el metodo getter
                	valorBlob=(Blob)metodoBean.invoke(bean);
                    if(valorBlob==null){
                        respuestaFinal[0]=Constantes.STR_CODIGOEXITO[0];
                        respuestaFinal[1]=null;
                    }else{
                        respuestaFinal[0]=Constantes.STR_CODIGOEXITO[0];
                        respuestaFinal[1]=getBeanValue(valorBlob, numTabs+1);
                        respuestaFinal[2]=valorBlob;
                    }
                   return respuestaFinal;
                }
                // si es un map 
                if(esMap(atributo)){
                    //ejecutamos el metodo getter
                	valorMap=(Map)metodoBean.invoke(bean);
                    if(valorMap==null){
                        respuestaFinal[0]=Constantes.STR_CODIGOEXITO[0];
                        respuestaFinal[1]=null;
                    }else{
                        respuestaFinal[0]=Constantes.STR_CODIGOEXITO[0];
                        respuestaFinal[1]=getBeanValue(valorMap, numTabs+1);
                        respuestaFinal[2]=valorMap;
                    }
                   return respuestaFinal;
                }
                
                if(esCardinalBean(atributo)){
                	//ejecutamos el metodo getter
                	valorMap=(Map)metodoBean.invoke(bean);
                    if(valorMap==null){
                        respuestaFinal[0]=Constantes.STR_CODIGOEXITO[0];
                        respuestaFinal[1]=null;
                    }else{
                        respuestaFinal[0]=Constantes.STR_CODIGOEXITO[0];
                        respuestaFinal[1]=getBeanValue(valorMap, numTabs+1);
                        respuestaFinal[2]=valorMap;
                    }
                   return respuestaFinal;
                }
                metodoBean=mapeaBean.getGetterName(bean, atributo.getName());
                Object value = metodoBean.invoke(bean);
                if(objectoEsUnBean(value)[0].equals(Constantes.STR_CODIGOEXITO[0])){
                    if(value==null){
                        respuestaFinal[0]=Constantes.STR_CODIGOEXITO[0];
                        respuestaFinal[1]=null;
                    }else{
                        respuestaFinal[0]=Constantes.STR_CODIGOEXITO[0];
                        respuestaFinal[1]=getBeanValue(value, numTabs+1);
                        respuestaFinal[2]=value;
                    }
                   return respuestaFinal;
                }
                /* si se ha llegado hasta esta linea, es xq no ha entrado e ninguna
                 de las opciones de arriba, por tanto hay un tipo de dato 
                no soportado*/
                respuestaFinal[0]="002";
                respuestaFinal[1]="Error: tipo de dato no soportado "+atributo.getType().getSimpleName();
                
                
            }catch(IllegalAccessException ex){
                respuestaFinal[0]="003";
                respuestaFinal[1]="Error:getter no es publico" ;  
                //System.out.println(ex.getMessage());
                //ErrorEjecutarMetodo=true;
            }catch(InvocationTargetException exe){
                respuestaFinal[0]="004";
                respuestaFinal[1]="Error al invocar el getter" ;   
                //System.out.println(exe.getMessage());
                //ErrorEjecutarMetodo=true;
                }
        }
        
        
        
        return respuestaFinal;
    }
    
    
    /**
    * @Autor: mreyes
    * @param: Object bean, Field atributos
    * @return String[2]
    * @Fecha: 15/06/2015
    * @DescripcionGeneral: determina si el objeto de entrada es un bean
    * @DescripcionDetallada: como parametros de entrada recibe la instancia de un objeto(bean), array atributos del objeto(bean)
    * para determinar si un objeto es un bean, se recorren
         * todos sus aitributos, buscando sus getters  y setters los cuales deben ser publicos, si ocurre un
         * error al buscar un metodo getter/stter que le corresṕonda a un
         * atributo se asumira que no es un bean
         * 
         * codigo devueltos:    Constantes.STR_CODIGOEXITO[0]=indica que todos los stters y getters fueron encontrados segun sus atributos
         *                      001=Error:metodo getter no encontrado para atributo
         *                      002=Error:metodo setter no encontrado para atributo
    */
    public static String[] objectoEsUnBean(Object bean){
        String[] respuesta=new String[2];
        respuesta[0]="003";
        respuesta[1]="Error:desconocido ";
        Class clase = bean.getClass();
        
        Class   superClase=clase.getSuperclass();
        Field[] atributos= junta(clase.getDeclaredFields(),superClase.getDeclaredFields());  
        if(atributos.length==0){
        	respuesta[0]=Constantes.STR_CODIGOEXITO[0];
            respuesta[1]="bean sin atributos";
        }
        for(int i=0;i<atributos.length;i++){
            Method metodSetter=getSetterName(bean, atributos[i].getName());
            Method metodGetter=getGetterName(bean, atributos[i].getName());
            // si no se ha encontrado el metodo getter, entonces no es un bean
            if(metodGetter==null){
                respuesta[0]="001";
                respuesta[1]="Error:metodo getter no encontrado para atributo: "+atributos[i].getName();
                return respuesta;
            }else 
                if( metodSetter==null){
                    respuesta[0]="002";
                    respuesta[1]="Error:metodo setter no encontrado para atributo: "+atributos[i].getName();
                    return respuesta;
                }else{
                     respuesta[0]=Constantes.STR_CODIGOEXITO[0];
                     respuesta[1]="stters y getters encontrados ";
                 }
            
        }
        
        return respuesta;
        
    }
    
    /**
    * @Autor: mreyes
    * @param: Object bean, Field atributos
    * @return Boolean
    * @Fecha: 15/06/2015
    * @DescripcionGeneral: determina si el bean de entrada trae todos sus getter correspoendientes a sus atributos
    * @DescripcionDetallada: como parametros de entrada recibe la instancia de un objeto(bean), array atributos del objeto(bean)
    * 
    */
    private static Boolean beanTraeTodosGetters(Object bean,Field[] atributos){
        Boolean respuesta=false;
        for(int i=0;i<atributos.length;i++){
            Method metodGetter=getGetterName(bean, atributos[i].getName());
            // si no se ha encontrado el metodo getter, entonces no es un bean
            if(metodGetter==null){
                //System.out.println(atributos[i].getName());
                return false;
            }else{
                respuesta=true;
            }
        }
        
        return respuesta;
        
    }
    
    /**
    * @Autor: mreyes
    * @param: Object bean, Field atributos
    * @return Boolean
    * @Fecha: 15/06/2015
    * @DescripcionGeneral: determina si el bean de entrada trae todos sus setter correspoendientes a sus atributos
    * @DescripcionDetallada: como parametros de entrada recibe la instancia de un objeto(bean), array atributos del objeto(bean)
    * 
    */
    private static Boolean beanTraeTodosSetters(Object bean,Field[] atributos){
        Boolean respuesta=false;
        for(int i=0;i<atributos.length;i++){
            Method metodSetter=getSetterName(bean, atributos[i].getName());
            // si no se ha encontrado el metodo getter, entonces no es un bean
            if(metodSetter==null){
                return false;
            }else{
                respuesta=true;
            }
        }
        
        return respuesta;
        
    }
    
    
    /**
    * @Autor: mreyes
    * @param: Field[] a, Field[] b
    * @return Field[]
    * @Fecha: 15/06/2015
    * @DescripcionGeneral: combina 2 arrays de tipo Field
    * @DescripcionDetallada: 
    */
    private static Field[] junta(Field[] a, Field[] b){
            int length = a.length + b.length;
            Field[] result = new Field[length];
            System.arraycopy(a, 0, result, 0, a.length);
            System.arraycopy(b, 0, result, a.length, b.length);
            return result;
        }

    /**
    * @Autor: mreyes
    * @param: Object obj, int numTabs
    * @return String
    * @Fecha: 15/06/2015
    * @DescripcionGeneral: obtiene el valor de los elementos de una lista
    * @DescripcionDetallada: 
    */
    private static String procesaLista(Object obj,int numTabs){
        List lista=(ArrayList)obj;
        StringBuffer valorStringB= new StringBuffer("");
        if(lista.size()==0){
            valorStringB.append("Lista vacia");
        }
        for(int i=0; i<lista.size();i++){
            valorStringB.append("\n");//.append(getTab(numTabs)); 
            valorStringB.append(getBeanValue(lista.get(i), numTabs));                                                 
        }
        return valorStringB.toString();
    }
    
    
    /**
    * @Autor: mreyes
    * @param: Object obj, int numTabs
    * @return String
    * @Fecha: 15/06/2015
    * @DescripcionGeneral: obtiene el valor de los elementos de un arreglo
    * @DescripcionDetallada: 
    */
    private static String procesaArreglo(Object[] obj,int numTabs){        
        StringBuffer valorStringB= new StringBuffer("");
        if(obj.length==0){
            valorStringB.append("arreglo vacio");
        }
        for(int i=0; i<obj.length;i++){
            valorStringB.append("\n");//.append(getTab(numTabs)); 
            valorStringB.append(getBeanValue(obj[i], numTabs));                                                 
        }
        return valorStringB.toString();
    }
    
    /**
    * @Autor: jperez
    * @param: Object obj, int numTabs
    * @return String
    * @Fecha: 07/08/2018
    * @DescripcionGeneral: Obtiene la representacion de un Map
    * @DescripcionDetallada: 
    */
    private static String procesaMap(Map mapa, int numTabs){        
        StringBuilder valorStringB = new StringBuilder("");
        Set llaves = mapa.keySet();
        if(llaves == null || llaves.isEmpty()) {
        	return valorStringB.toString();
        }
        
        valorStringB.append("\n");
        for(Object llave: llaves) {
        	Object objeto = mapa.get(llave);  
        	String valorObjeto = null;
        	if(esCardinalBean(objeto)) {
        		valorObjeto = getBeanValue(objeto, numTabs + 1);
        	}
        	else {
        		valorObjeto = getBeanValue(objeto, -1);
        	}

        	valorStringB.append(getTab(numTabs));
        	valorStringB.append(llave.toString()).append(":").append(valorObjeto);
        	valorStringB.append("\n");
        }
        if(valorStringB.length() > 1) {
        	valorStringB.delete(valorStringB.length() - 1, valorStringB.length());
        }        
        
        
        return valorStringB.toString();
    }
    
    /**
    * @Autor: mreyes
    * @param: Object obj, int numTabs
    * @return String
    * @Fecha: 15/06/2015
    * @DescripcionGeneral: obtiene el valor de los elementos de un Bean
    * @DescripcionDetallada: 
    */
    private static String procesaBean(Object bean, Field[]atributos, int numTabs){
        StringBuffer resultado=new StringBuffer("");
        Object[] value=new Object[3];
        
         for (int x=0;x<atributos.length;x++){
            value=getValue(bean, atributos[x],numTabs);
            if(existeElementoLista(getDatosEnmascarar(),atributos[x].getName())==true
                &&  value[0].equals(Constantes.STR_CODIGOEXITO[0])){
                value[1]=Constantes.STR_ENMASCARADOS;
            }
            resultado.append(getTab(numTabs));
            resultado.append(atributos[x].getName()).append(": ");
            resultado.append(value[1]).append("\n");
        }
        
        return resultado.toString();
    }
    
    /**
    * @Autor: mreyes
    * @param: Object bean, int numTabs
    * @return String
    * @Fecha: 15/06/2015
    * @DescripcionGeneral: metodo principal y publico para obtener los valosres de los atributos de  un objeto
    * @DescripcionDetallada: objetos soportados: Listas, Arreglos, Beans, Tipo Datos primitivos y sus semejantes en objetos
    */
    public static String getBeanValue(Object bean, int numTabs){        
        StringBuffer resultado=new StringBuffer("");
        try{
            if(bean==null){
                resultado.append(getTab(numTabs)).append("null");
            }else{
            	if( numTabs ==0){
            		resultado.append("\n");
            	}
                Class clase = bean.getClass();
                
                Class   superClase=clase.getSuperclass();

                // obtenemos todos los atributos public y private y protected
                Field[] atributos= junta(clase.getDeclaredFields(),superClase.getDeclaredFields());                    
                if(beanTraeTodosGetters(bean,atributos)){                    
                    resultado.append(procesaBean(bean, atributos, numTabs)); 
                }else
                if(esLista(bean)){
                    resultado.append(procesaLista(bean,numTabs));
                }else
                if(esString(bean)){
                    resultado.append(getTab(numTabs)).append(bean);
                }else
                if(esEntero(bean)){
                    resultado.append(getTab(numTabs)).append(bean.toString());
                }else
                if(esDouble(bean)){
                    resultado.append(getTab(numTabs)).append(bean.toString());
                }else
                if(esBooleano(bean)){
                    resultado.append(getTab(numTabs)).append(bean.toString());
                }else
                if(esFecha(bean)){
                    //resultado.append(getTab(numTabs)).append(Fechas.convierteStr((Date)bean, Fechas.FORMATO.AAAA_MM_DD_SinGuion));                    
                    resultado.append(getTab(numTabs)).append((Date)bean);
                }else
                if(esArreglo(bean)){
                    resultado.append(procesaArreglo((Object[])bean,numTabs));
                }else
                if(esBlob(bean)){
                    resultado.append("Dato tipo Blob");
                }else 
                if(esMap(bean)){
                	resultado.append(procesaMap((Map) bean, numTabs));
                }
                else{
                	resultado.append(getTab(numTabs)).append("El obj: ").append(clase.getSimpleName()).append(" no puede imprimirse en el log por no cumplir las reglas de un 'bean'");      
                }
            }
        }catch(Exception e) {
            resultado.append(getTab(numTabs)).append("Error :)");            
        }
        return resultado.toString();
    
    }
    
    
    public static List valoresDeafultALista(List lista){
        
        String  stringVacio="";
        Integer enteroVacio=0;
        Boolean booleanoVacio=false;
        Double  doubleVacio=0.00;
        Date    dateVacio= Utileria.convierteDate("1900-01-01", mapeaBean.FORMATO.AAAA_MM_DD_SinGuion);
        List    listaVacia=new ArrayList();
        Object[] arregloVacio=new Object[0];
        
        if(lista==null){
            return listaVacia;
        }
        
        for(int i=0; i<lista.size();i++){
            if(esString(lista.get(i)) && lista.get(i)==null){
                lista.set(i, stringVacio);
            }else
            if(esEntero(lista.get(i))&& lista.get(i)==null){
                lista.set(i, enteroVacio);
            }else
            if(esDouble(lista.get(i))&& lista.get(i)==null){ 
                lista.set(i, doubleVacio);
            }else
            if(esBooleano(lista.get(i))&& lista.get(i)==null){
                lista.set(i, booleanoVacio);
            }else
            if(esFecha(lista.get(i))&& lista.get(i)==null){                                        
                lista.set(i, dateVacio);
            }else
            if(esArreglo(lista.get(i))&& lista.get(i)==null){
                lista.set(i, arregloVacio);
            }else
            if(esArreglo(lista.get(i))&& lista.get(i)!=null){
                lista.set(i, valoresDefaultAArray((Object[])lista.get(i)));
            }else
            if(esLista(lista.get(i))&& lista.get(i)==null){
                lista.set(i, stringVacio);
            }else
            if(esLista(lista.get(i))&& lista.get(i)!=null){
                lista.set(i, valoresDeafultALista((List)lista.get(i)));
            }else{
                    String[] esBeanPuro=new String[2];
                    esBeanPuro=objectoEsUnBean(lista.get(i));
                    if(esBeanPuro[0].equals(Constantes.STR_CODIGOEXITO[0])&& lista.get(i)!=null){
                        lista.set(i, valoresDefaultABean(lista.get(i)));
                    }
                }
        }
        
        
        return lista;
    }

    public static Object[] valoresDefaultAArray(Object[] arreglo){
    	
        String  stringVacio="";
        Integer enteroVacio=0;
        Boolean booleanoVacio=false;
        Double  doubleVacio=0.00;
        Date    dateVacio= Utileria.convierteDate("1900-01-01",mapeaBean.FORMATO.AAAA_MM_DD_SinGuion);
        List    listaVacia=new ArrayList();
        Object[] arregloVacio=new Object[0];
        
        if(arreglo==null){
            return arregloVacio;
        }
        
        for(int x=0; x<arreglo.length;x++){
                if(esString(arreglo[x]) && arreglo[x]==null){
                    arreglo[x]=stringVacio;
                }else
                if(esEntero(arreglo[x])&& arreglo[x]==null){
                    arreglo[x]=enteroVacio;
                }else
                if(esDouble(arreglo[x])&& arreglo[x]==null){
                    arreglo[x]=doubleVacio;                    
                }else
                if(esBooleano(arreglo[x])&& arreglo[x]==null){
                    arreglo[x]=booleanoVacio;
                }else
                if(esFecha(arreglo[x])&& arreglo[x]==null){                                        
                    arreglo[x]=dateVacio;
                }else
                if(esArreglo(arreglo[x])&& arreglo[x]==null){
                    arreglo[x]=arregloVacio;
                }else
                if(esArreglo(arreglo[x])&& arreglo[x]!=null){
                   arreglo[x]= valoresDefaultAArray((Object[])arreglo[x]);
                }else
                if(esLista(arreglo[x])&& arreglo[x]==null){
                    arreglo[x]=listaVacia;
                }else
                if(esLista(arreglo[x])&& arreglo[x]!=null){
                    arreglo[x]=(List)valoresDeafultALista((List)arreglo[x]);
                }else{
                    String[] esBeanPuro=new String[2];
                    esBeanPuro=objectoEsUnBean(arreglo[x]);
                    if(esBeanPuro[0].equals(Constantes.STR_CODIGOEXITO[0])&& arreglo[x]!=null){
                        arreglo[x]=valoresDefaultABean(arreglo[x]);
                    }
                }
        }
        return arreglo;
    }


    public static Object valoresDefaultABean(Object bean){        
        Object[] value= new String[2];
        String[] esBeanPuro=new String[2];
        String  stringVacio="";
        Integer enteroVacio=0;
        Boolean booleanoVacio=false;
        Double  doubleVacio=0.00;
        Date    dateVacio= Utileria.convierteDate("1900-01-01" ,mapeaBean.FORMATO.AAAA_MM_DD_Guion);
        List    listaVacia=new ArrayList();
        Object[] arregloVacio=new Object[0];
        
       
        try{
            if(bean==null){
                return bean;
            }//else{
                Class clase = bean.getClass();
                
                Class   superClase=clase.getSuperclass();
                
                
                // obtenemos todos los atributos public y private y protected
                Field[] atributos= junta(clase.getDeclaredFields(),superClase.getDeclaredFields());     
                // verificamos si es un bean puro
                esBeanPuro=objectoEsUnBean(bean);
                if(esBeanPuro[0].equals(Constantes.STR_CODIGOEXITO[0])){
                	
                	//Es posible realizar esta misma comprobación con: Class.isAssignableFrom
                	if(!mostrarMensajesErrorGenericos && bean instanceof BaseBeanResponseWS){
                		enmascararErroresGenericos(bean);
                	}
                	
                    // se empieza a recorrer los atributos del bean
                    for (int x=0;x<atributos.length;x++){                          
                        // obtenemos el metodo setter del atributo en curso
                        Method metodoSetter=getSetterName(bean, atributos[x].getName());                        
                        // obtenemos el valor del atributo en curso
                        value=getValue(bean, atributos[x],0);  
                        
                        // vericamos si hemos obtenido el valor con exito
                        if(value[0].equals(Constantes.STR_CODIGOEXITO[0])){
                            
                            try{
                                
                                //dependiendo del tipo del atributo es el valor que se seteara
                                
                                if(esString(atributos[x]) && value[1]==null){
                                    // invocamo el setter
                                    metodoSetter.invoke(bean, stringVacio);                                    
                                }else
                                if(esEntero(atributos[x])&& value[1]==null){
                                    metodoSetter.invoke(bean, enteroVacio);
                                }else
                                if(esDouble(atributos[x])&& value[1]==null){
                                    metodoSetter.invoke(bean, doubleVacio);
                                }else
                                if(esBooleano(atributos[x])&& value[1]==null){
                                    metodoSetter.invoke(bean, booleanoVacio);
                                }else
                                if(esFecha(atributos[x])&& value[1]==null){
                                    metodoSetter.invoke(bean, dateVacio);
                                }else
                                    //sandoval
                               /* if(esArreglo(atributos[x])&& value[1]==null){
                                    //System.out.println(atributos[x].getType().getSimpleName()+" jdjdjdjdj");
                                    metodoSetter.invoke(bean, obtenerarreglovacio());
                                }else*/
                                if(esArreglo(atributos[x])&& value[1]!=null){                                    
                                    metodoSetter.invoke(bean, valoresDefaultAArray((Object[])value[2]));
                                }else
                                if(esLista(atributos[x])&& value[1]==null){
                                    metodoSetter.invoke(bean, listaVacia);
                                }else
                                if(esLista(atributos[x])&& value[1]!=null){
                                    metodoSetter.invoke(bean, valoresDeafultALista((List)value[2]));
                                }
                                
                            }catch(IllegalAccessException illegalAccessException){
                                //loggerWSFDB.info("no se podra settear valor deafult al atributo: "+atributos[x].getName()+ "por que el setter no es publico");
                                System.out.println("no se podra settear valor deafult al atributo: "+atributos[x].getName()+ "por que el setter no es publico");
                            }catch(InvocationTargetException invocationTargetException){
                                //loggerWSFDB.info("ocurrio un error al invocar el metodo set para el atributo: "+atributos[x].getName());
                                System.out.println("ocurrio un error al invocar el metodo set para el atributo: "+atributos[x].getName());
                            }
                        }else{// si no pudimos obtente con exito el valor para el atributo correspondiente, logueamos
                            //loggerWSFDB.info("no se podra settear valor deafult al atributo: "+atributos[x].getName());
                            System.out.println("no se podra settear valor deafult al atributo: "+atributos[x].getName());
                            //loggerWSFDB.info(value[0]+": "+value[1]);
                             System.out.println(value[0]+": "+value[1]);
                        }
                        
                        
                                                       
                    } 
                    //resultado.append(procesaBean(bean, atributos, numTabs));                   
                }else{
                    //loggerWSFDB.info("el objeto de entradano es un bean puro razones:");
                    System.out.println("el objeto de entradano es un bean puro razones:");
                    //loggerWSFDB.info(esBeanPuro[1]);
                    System.out.println(esBeanPuro[1]);
                    return bean;
                }
                
            //}
        }catch(Exception e) {
            //oggerWSFDB.info("no se pudo poner valores deaful al bean");
            System.out.println("no se pudo poner valores deaful al bean ");
            System.out.println(e.getMessage());
            //e.printStackTrace();
        }
        return bean;
    }
        /**
         * Metodo para agregar elementos a la lista de datos a enmascarar*/
        public static void setDatosEnmascarar(String atributo) {
            datosEnmascarar.add(atributo); 
        }
        /**
         * @return: datosEnmascarar
         * Devuelve la lista de elementos a enmascarar
         * */
        public static List<String> getDatosEnmascarar() {
            return datosEnmascarar;
        }
        
        /**
         * Limpia la lista de datos enmascarados
         * */
        public static void limpiaListaEnmascarados(){
            if(datosEnmascarar.isEmpty()==false){
                datosEnmascarar.clear();
            }
        }
        
        /**
         * @param: elemento, Lista
         * @return: true o false
         * Metodo que busca un elemento dentro de una lista, recibe dos parametros una string y una lista de String
         * devuelve un Booleano si se encuentra el elemento dentro de la lista
         * */
        public static Boolean existeElementoLista(List<String> lista,String elemento){
            return lista.contains(elemento);
        }
        
	/**
	 * Substituye los mensajes de error de la arquitectura por un mensaje de error predefinido
	 * @param bean
	 * @author elopez
	 */
	private static void enmascararErroresGenericos(Object bean) {		
		BaseBeanResponseWS beanWSResponse = (BaseBeanResponseWS) bean;
		if(beanWSResponse.getCodigoRespuesta() != null){					
			if(		beanWSResponse.getCodigoRespuesta().equals(Constantes.STR_ERROR[0])
				||	beanWSResponse.getCodigoRespuesta().equals(Constantes.STR_ERROR_CONTROLADOR[0])
				||	beanWSResponse.getCodigoRespuesta().equals(Constantes.STR_ERROR_DAO[0])
				||	beanWSResponse.getCodigoRespuesta().equals(Constantes.STR_ERROR_SERVICIO[0])
				||	beanWSResponse.getCodigoRespuesta().equals(Constantes.STR_ERROR_VALIDACIONES[0])){
				beanWSResponse.setMensajeRespuesta(Constantes.STR_ERROR_ENMASCARADO+"WS-"+beanWSResponse.getClass().getSimpleName());
			}
		}
	}

    public static boolean isMostrarMensajesErrorGenericos() {
		return mostrarMensajesErrorGenericos;
	}

	public static void setMostrarMensajesErrorGenericos(boolean mostrarMensajesErrorGenericos) {
		mapeaBean.mostrarMensajesErrorGenericos = mostrarMensajesErrorGenericos;
	}	
	
	/**
	 * Funcion que devuelve los campos de la clase y de su superclase.
	 * 
	 * @param theClass
	 * @return
	 */
	public static Field[] getDeclaredFields(Class<?> theClass){
        Class superClase = theClass.getSuperclass();

        // obtenemos todos los atributos public y private y protected
        Field[] atributos= junta(theClass.getDeclaredFields(),superClase.getDeclaredFields()); 
        return atributos;
    }
        
    //Main de prueba
    /*public static void main(String[] args){
        String atributos[];
        Iterator iter;
        ComandoARHBean comando = new ComandoARHBean();
        comando.setComando("comandoGP");
        comando.setHostSocket("192.168.10.23");
        comando.setPuertoSocket(12);
        comando.setTimeOutSocket(123);
       mapeaBean.setDatosEnmascarar("comando");
       mapeaBean.setDatosEnmascarar("puertoSocket");
       
     // String valor=mapeaBean.enmascaraAtributo(comando, mapeaBean.getDatosEnmascarar()) ;
        System.out.println(mapeaBean.getBeanValue(comando,0));
     //mapeaBean.getBeanValue(comando,0);
        
    }
    */
    
	private static Field getField(Object bean, String AtributoBuscar){        
        Field resultado = null;
        try{
            if(bean==null){
                return null;
            }
            
            Class clase = bean.getClass();

            Class   superClase=clase.getSuperclass();

            // obtenemos todos los atributos public y private y protected
            Field[] atributos= junta(clase.getDeclaredFields(),superClase.getDeclaredFields());    
            for(Field atributo : atributos){
                if(atributo.getName().equals(AtributoBuscar.trim())){
                    return atributo;
                }
            }

        }catch(Exception e){
            resultado = null;
        }
        return resultado;
    }
	
	/**
    * @Autor: mreyes
    * @param: Object bean, Field atributo, int numTabs
    * @return Object[3]
    * @Fecha: 15/06/2015
    * @DescripcionGeneral: retorna un arreglo de 3 pocisiones, en la primera pocision retorna el codigo exito/error
    *                      en la segunda pociion retorna el valor/error en String obtenido del atributo especificado de un objeto(bean)
    *                      en la tercera pocision retorna el valo tal cual, si es un string, retorna un string, si es un array retorna un array etc.
    * @DescripcionDetallada: como parametros de entrada recibe la instancia de un objeto, el atributo al que se desea conocer su valor
    *                        y el numero de identacion(tabs)
    *                        
    *                        Codigos de exito y Error
    *                        Constantes.STR_CODIGOEXITO[0]=codigo Exito(el valor se ha obrenido exitosamente)
    *                        001=getter no encontrado para atributo 
    *                        002=Error: tipo de dato no soportado
    *                        003=Error:getter no es publico
    *                        004=Error al invocar el getter
    *                        005=Error, el atributo con el nombre[atributo] no existe
    *                        006=Error al buscar el atributo con el nombre[atributo]
    */
    public static Object[] getValue(Object bean, String atributo){
        Object[] respuestaFinal=new Object[3];
        Field fieldAtributo=null;;
       try {
           fieldAtributo = getField(bean,atributo);
           
           if(fieldAtributo == null){
               respuestaFinal[0]="005";
               respuestaFinal[1]="Error, el atributo con el nombre["+atributo+"] no existe";
               respuestaFinal[2]=null;
               return respuestaFinal;
           }
                       
           respuestaFinal = getValue(bean, fieldAtributo, 0);
           
       } catch (Exception e) {
           respuestaFinal[0]="006";
           respuestaFinal[1]="Error al buscar el atributo con el nombre["+atributo+"]";
           respuestaFinal[2]=null;
           e.printStackTrace();
       }
        
        return respuestaFinal;
    }

}
